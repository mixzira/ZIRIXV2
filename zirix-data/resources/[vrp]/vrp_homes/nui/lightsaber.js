let disabled = false;
let disabledFunction = null;

function Interval(time) {
	var timer = false
	this.start = function() {
		if (this.isRunning()) {
			clearInterval(timer)
			timer = false
		}

		timer = setInterval(function() {
			disabled = false
		}, time)
	}
	this.stop = function() {
		clearInterval(timer)
		timer = false
	}
	this.isRunning = function() {
		return timer !== false
	}
}

const disableInventory = ms => {
	disabled = true

	if (disabledFunction === null) {
		disabledFunction = new Interval(ms)
		disabledFunction.start()
	} else {
		if (disabledFunction.isRunning()) {
			disabledFunction.stop()
		}

		disabledFunction.start()
	}
}

$(document).ready(function(){
	let actionContainer = $("#actionmenu");

	window.addEventListener("message",function(event){
		let item = event.data;
		switch(item.action){
			case "showMenu":
				updateVault();
				actionContainer.fadeIn(500);
			break;

			case "hideMenu":
				actionContainer.fadeOut(500);
			break;

			case "updateVault":
				updateVault();
			break;
		}
	});

	document.onkeyup = function(data){
		if (data.which == 27){
			$.post("http://vrp_homes/chestClose");
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
			if (disabled) return false;

			$(this).children().children('img').hide();
			itemData = { key: $(this).data('item-key') };

			if (itemData.key === undefined) return;

			let $el = $(this);
			$el.addClass("active");
		},
		stop: function(){
			$(this).children().children('img').show();

			let $el = $(this);
			$el.removeClass("active");
		}
	})

	$('.item2').draggable({
		helper: 'clone',
		appendTo: 'body',
		zIndex: 99999,
		revert: 'invalid',
		opacity: 0.5,
		start: function(event,ui){
			if (disabled) return false;

			$(this).children().children('img').hide();
			itemData = { key: $(this).data('item-key') };

			if (itemData.key === undefined) return;

			let $el = $(this);
			$el.addClass("active");
		},
		stop: function(){
			$(this).children().children('img').show();

			let $el = $(this);
			$el.removeClass("active");
		}
	})

	$('.esquerda').droppable({
		hoverClass: 'hoverControl',
		accept: '.item2',
		drop: function(event,ui){
			itemData = { key: ui.draggable.data('item-key') };

			if (itemData.key === undefined) return;

			disableInventory(500);

			$.post("http://vrp_homes/takeItem", JSON.stringify({
				item: itemData.key,
				amount: Number($("#amount").val())
			}))

			document.getElementById("amount").value = "";
		}
	})

	$('.direita').droppable({
		hoverClass: 'hoverControl',
		accept: '.item',
		drop: function(event,ui){
			itemData = { key: ui.draggable.data('item-key') };

			if (itemData.key === undefined) return;

			disableInventory(500);

			$.post("http://vrp_homes/storeItem", JSON.stringify({
				item: itemData.key,
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

const updateVault = () => {
	$.post("http://vrp_homes/requestVault",JSON.stringify({}),(data) => {
		const nameList = data.inventario.sort((a,b) => (a.name > b.name) ? 1: -1);
		const nameList2 = data.inventario2.sort((a,b) => (a.name > b.name) ? 1: -1);
		$('#inventory').html(`
			
			<div class="peso"><b>EM USO:</b>  ${(data.peso).toFixed(2)}Kg    <s>|</s>    <b>DISPONÍVEL:</b>  ${(data.maxpeso-data.peso).toFixed(2)}Kg    <s>|</s>    <b>TAMANHO:</b>  ${(data.maxpeso).toFixed(2)}Kg</div>
			<div class="peso2"><b>EM USO:</b>  ${(data.peso2).toFixed(2)}Kg    <s>|</s>    <b>DISPONÍVEL:</b>  ${(data.maxpeso2-data.peso2).toFixed(2)}Kg    <s>|</s>    <b>TAMANHO:</b>  ${(data.maxpeso2).toFixed(2)}Kg</div>
			
			
			<div class="esquerda">
				${nameList2.map((item) => (`
					<div class="item" data-item-key="${item.key}">
						<div class="thumb"><img src='http://192.99.251.232:3554/images/vrp_itens/${item.index}.png'></div>	
						<div id="peso">${(item.peso*item.amount).toFixed(2)}Kg</div>
						<div id="quantity">${formatarNumero(item.amount)}x</div>
						<div id="itemname">${item.name}</div>
					</div>
				`)).join('')}
			</div>

			<div class="meio">
				<input id="amount" class="qtd" maxlength="9" spellcheck="false" value="" placeholder="QUANTIDADE">
			</div>

			<div class="direita">
				${nameList.map((item) => (`
					<div class="item2" data-item-key="${item.key}">
						<div class="thumb"><img src='http://192.99.251.232:3554/images/vrp_itens/${item.index}.png'></div>		
						<div id="peso">${(item.peso*item.amount).toFixed(2)}Kg</div>
						<div id="quantity">${formatarNumero(item.amount)}x</div>
						<div id="itemname">${item.name}</div>
					</div>
				`)).join('')}
			</div>
		`);
		$('#pesoinfo').html(`
			<div class="peso"><b>EM USO:</b>  ${(data.peso).toFixed(2)}Kg    <s>|</s>    <b>DISPONÍVEL:</b>  ${(data.maxpeso-data.peso).toFixed(2)}Kg     <s>|</s>    <b>TAMANHO:</b>  ${(data.maxpeso).toFixed(2)}Kg</div>
		`);
		updateDrag();
	});
}