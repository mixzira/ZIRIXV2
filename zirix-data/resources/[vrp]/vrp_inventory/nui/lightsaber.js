$(document).ready(function(){
	window.addEventListener("message",function(event){
		switch(event.data.action){
			case "showMenu":
				updateMochila();
				$("#actionmenu").fadeIn(500);
			break;

			case "hideMenu":
				$("#actionmenu").fadeOut(500);
			break;

			case "updateMochila":
				updateMochila();
			break;
		}
	});

	document.onkeyup = function(data){
		if (data.which == 27){
			$.post("http://vrp_inventory/invClose");
		}
	};
});

const updateDrag = () => {
	$('.item').draggable({
		helper: 'clone',
		appendTo: 'body',
		zIndex: 99999,
		revert: 'invalid',
		opacity: 0.5,
		start: function(event,ui){
			$(this).children().children('img').hide();
			itemData = { key: $(this).data('item-key'), type: $(this).data('item-type') };

			if (itemData.key === undefined || itemData.type === undefined) return;

			let $el = $(this);
			$el.addClass("active");
		},
		stop: function(){
			$(this).children().children('img').show();

			let $el = $(this);
			$el.removeClass("active");
		}
	})

	$('.usar').droppable({
		hoverClass: 'hoverControl',
		drop: function(event,ui){
			itemData = { key: ui.draggable.data('item-key'), type: ui.draggable.data('item-type') };

			if (itemData.key === undefined || itemData.type === undefined) return;

			$.post("http://vrp_inventory/usarItem", JSON.stringify({
				item: itemData.key,
				type: itemData.type,
				amount: Number($("#amount").val())
			}))

			document.getElementById("amount").value = "";
		}
	})

	$('.dropar').droppable({
		hoverClass: 'hoverControl',
		drop: function(event,ui){
			itemData = { key: ui.draggable.data('item-key'), type: ui.draggable.data('item-type') };

			if (itemData.key === undefined || itemData.type === undefined) return;

			$.post("http://vrp_inventory/droparItem", JSON.stringify({
				item: itemData.key,
				type: itemData.type,
				amount: Number($("#amount").val())
			}))

			document.getElementById("amount").value = "";
		}
	})

	$('.enviar').droppable({
		hoverClass: 'hoverControl',
		drop: function(event,ui){
			itemData = { key: ui.draggable.data('item-key'), type: ui.draggable.data('item-type') };

			if (itemData.key === undefined || itemData.type === undefined) return;

			$.post("http://vrp_inventory/enviarItem", JSON.stringify({
				item: itemData.key,
				type: itemData.type,
				amount: Number($("#amount").val())
			}))

			document.getElementById("amount").value = "";
		}
	})
}

const formatarNumero = (n) => {
	var n = n.toString();
	var r = '';
	var x = 0;

	for (var i = n.length; i > 0; i--) {
		r += n.substr(i - 1, 1) + (x == 2 && i != 1 ? '.' : '');
		x = x == 2 ? 0 : x + 1;
	}

	return r.split('').reverse().join('');
}

const updateMochila = () => {
	document.getElementById("amount").value = "";
	$.post("http://vrp_inventory/requestMochila",JSON.stringify({}),(data) => {
		const nameList = data.inventario.sort((a,b) => (a.name > b.name) ? 1: -1);
		$('#inventario-items').html(`
			${nameList.map((item) => (`
				<div class="item" data-item-key="${item.key}" data-item-type="${item.type}" data-name-key="${item.name}">
					<div id="thumb"><img src='${data.ip}/images/vrp_itens/${item.index}.png'></div>	
					<div id="peso">${(item.peso*item.amount).toFixed(2)}Kg</div>
					<div id="quantity">${formatarNumero(item.amount)}x</div>
					<div id="itemname">${item.name}</div>
				</div>
			`)).join('')}
		`);
		$('#pesoinfo').html(`
			<div class="peso"><b>EM USO:</b>  ${(data.peso).toFixed(2)}Kg    <s>|</s>    <b>DISPONÍVEL:</b>  ${(data.maxpeso-data.peso).toFixed(2)}Kg     <s>|</s>    <b>TAMANHO:</b>  ${(data.maxpeso).toFixed(2)}Kg</div>
		`);
		$('#inventario-titulo').html(`
			<div class="pesomochila">
				<div id="pesoinfo"></div>
			</div>
			<input id="amount" class="qtd" maxlength="9" spellcheck="false" value="" placeholder="Quantidade">
			<div class="usar"><img src="${data.ip}/images/vrp_itens/usar.png"></div>
			<div class="enviar"><img src="${data.ip}/images/vrp_itens/enviar.png"></div>
			<div class="dropar"><img src="${data.ip}/images/vrp_itens/dropar.png"></div>
		`);
		updateDrag();
	});
}