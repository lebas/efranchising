# encoding: utf-8
#  Cielo.setup do |config|
#    config.environment = :test
#    config.numero_afiliacao = cieloconf.numero
#    config.chave_acesso = cieloconf.merchant_id
#    config.return_path = "https://meudominio.com.br/checkout"
#    conf = true
#  end

require 'active_support/core_ext/class/attribute_accessors'
require 'active_support/core_ext/module/attribute_accessors'
require 'active_support/core_ext/hash'
require "net/http"
require "rexml/document"
require "builder"

module Cielo

  class Production
    BASE_URL = "ecommerce.cbmp.com.br"
    WS_PATH = "/servicos/ecommwsec.do"
    ssl_verify_mode = OpenSSL::SSL::VERIFY_NONE
  end

  class Test
    BASE_URL = "qasecommerce.cielo.com.br"
    WS_PATH = "/servicos/ecommwsec.do"
    ssl_verify_mode = OpenSSL::SSL::VERIFY_NONE
  end
  
  @@environment = :test
  mattr_accessor :environment
  @@numero_afiliacao = ""
  mattr_accessor :numero_afiliacao
  @@chave_acesso=""
  mattr_accessor :chave_acesso
  @@return_path = "/checkout"
  mattr_accessor :return_path

  def self.setup
    yield self
  end

  class Connection
    attr_reader :environment
    def initialize
      @environment = eval(CieloHelper.environment.to_s.capitalize)
      port = 443
      @http = Net::HTTP.new(@environment::BASE_URL,port)
      @http.use_ssl = true
      @http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      @http.ca_path = '/etc/ssl/certs' if File.exists?('/etc/ssl/certs') # Ubuntu
      @http.ca_file = '/opt/local/share/curl/curl-ca-bundle.crt' if File.exists?('/opt/local/share/curl/curl-ca-bundle.crt') # Mac OS X      
      
      @http.open_timeout = 10*1000
      @http.read_timeout = 40*1000
    end
    
    def request!(params={})
      str_params = ""
      params.each do |key, value| 
        str_params+="&" unless str_params.empty?
        str_params+="#{key}=#{value}"
      end
      
      Rails.logger.info "Enviando XML para Cielo: #{str_params}"
      @http.request_post(self.environment::WS_PATH, str_params)
    end
  end

  class Transaction
    def initialize
      @connection = Cielo::Connection.new
    end
    def create!(parameters={})
      analysis_parameters(parameters)
      message = xml_builder("requisicao-transacao") do |xml|

        if parameters[:"numero-cartao"] != nil
          xml.tag!("dados-portador") do
            [:"numero-cartao", :validade, :indicador, :"codigo-seguranca"].each do |key|
              xml.tag!(if key == :"numero-cartao" then "numero" else key.to_s end, parameters[key].to_s)
            end
          end
        end
        xml.tag!("dados-pedido") do
          [:numero, :valor, :moeda, :"data-hora", :idioma].each do |key|
            xml.tag!(key.to_s, parameters[key].to_s)
          end
        end
        xml.tag!("forma-pagamento") do
          [:bandeira, :produto, :parcelas].each do |key|
            xml.tag!(key.to_s, parameters[key].to_s)
          end
        end
        xml.tag!("url-retorno", parameters[:"url-retorno"])
        xml.autorizar parameters[:autorizar].to_s
        xml.capturar parameters[:capturar].to_s
      end
      make_request! message
    end

    def verify!(cieloloja_tid)
      return nil unless cieloloja_tid
      message = xml_builder("requisicao-consulta", :before) do |xml|
        xml.tid "#{cieloloja_tid}"
      end
      
      make_request! message
    end
    
    def catch!(cieloloja_tid)
      return nil unless cieloloja_tid
      message = xml_builder("requisicao-captura", :before) do |xml|
        xml.tid "#{cieloloja_tid}"
      end
      make_request! message
    end
    
    private
    def analysis_parameters(parameters={})
      [:numero, :valor, :bandeira, :"url-retorno"].each do |parameter|
        raise Cielo::MissingArgumentError, "Required parameter #{parameter} not found" unless parameters[parameter]
      end
      parameters.merge!(:moeda => "986") unless parameters[:moeda]
      parameters.merge!(:"data-hora" => Time.now.strftime("%Y-%m-%dT%H:%M:%S")) unless parameters[:"data-hora"]
      parameters.merge!(:idioma => "PT") unless parameters[:idioma]
      parameters.merge!(:produto => "1") unless parameters[:produto]
      parameters.merge!(:parcelas => "1") unless parameters[:parcelas]
      parameters.merge!(:autorizar => "2") unless parameters[:autorizar]
      parameters.merge!(:capturar => "true") unless parameters[:capturar]
      parameters.merge!(:"url-retorno" => CieloHelper.return_path) unless parameters[:"url-retorno"]
      parameters
    end

    def xml_builder(group_name, target=:after, &block)
      xml = Builder::XmlMarkup.new
      xml.instruct! :xml, :version=>"1.0", :encoding=>"ISO-8859-1"
      xml.tag!(group_name, :id => "#{Time.now.to_i}", :versao => "1.1.0") do
        block.call(xml) if target == :before
        xml.tag!("dados-ec") do
          xml.numero CieloHelper.numero_afiliacao
          xml.chave CieloHelper.chave_acesso
        end
        block.call(xml) if target == :after
      end
      xml
    end
    
    def make_request!(message)
      params = { :mensagem => message.target! }
      
      result = @connection.request! params
      parse_response(result)
    end
    
    def parse_response(response)
      case response
      when Net::HTTPSuccess
        document = REXML::Document.new(response.body)
        parse_elements(document.elements)
      else
        {:erro => { :codigo => "000", :mensagem => "Impossível contactar o servidor"}}
      end
    end

   def parse_elements(elements)
      map={}
      elements.each do |element|
        element_map = {}
        element_map = element.text if element.elements.empty? && element.attributes.empty?
        element_map.merge!("value" => element.text) if element.elements.empty? && !element.attributes.empty?
        element_map.merge!(parse_elements(element.elements)) unless element.elements.empty?
        map.merge!(element.name => element_map)
      end
      map.symbolize_keys
    end
  end
end
