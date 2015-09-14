$(document).ready(function() {
  $().toastmessage('showNoticeToast', "Clique em cada Aba do Cardápio para descobrir nossos pratos.");
  $('.botao_add_cart').click(function () {
    var target = document.getElementById('spinner');
    target.style.background="rgba(0,0,0,0.36)";
    var opts = { lines: 17, length: 10, width: 12, radius: 60, corners: 1, rotate: 0, direction: 1, color: '#FFF', speed: 1.3, trail: 58, shadow: true, hwaccel: false, className: 'spinner', zIndex: 2e9, top: '50%', left: '50%' };
    var spinner = new Spinner(opts).spin(target);
    var data = {};
    data.produto_id = this.id;
    data.qtd_produto = document.getElementById("qtd_food-"+data.produto_id).value;
    $.post("/abamode/", data, function(responseData) {
      $('#num_itens')[0].innerHTML =responseData.itens_cart;
      $('#valor_itens')[0].innerHTML=responseData.total_cart;
    });
  });

  $( ".accordion" ).accordion({ autoHeight: false, collapsible: true, navigation: true, heightStyle: "content" });
  $('.unavailable-button').button().on( "click", function()  {
    var data = {}
    data.barcode = $('.unavailable-button').attr('value');
    $.post('/warnings', data, function(responseData) {
    });
  });

  $('.box_menu_store').click(function () {
    var target = document.getElementById('spinner');
    target.style.background="rgba(0,0,0,0.36)";
    var opts = { lines: 17, length: 10, width: 12, radius: 60, corners: 1, rotate: 0, direction: 1, color: '#FFF', speed: 1.3, trail: 58, shadow: true, hwaccel: false, className: 'spinner', zIndex: 2e9, top: '50%', left: '50%' };
    var spinner = new Spinner(opts).spin(target);
  });
});