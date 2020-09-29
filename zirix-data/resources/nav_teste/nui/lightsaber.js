$(function() {
	init();
	var actionContainer = $(".actionmenu");
	window.addEventListener("message", function(event) {
		var item = event.data;

		if (item.showmenu) {
			ResetMenu();
			$('body').css('background-color', 'rgba(0, 0, 0, 0.15)')
			actionContainer.fadeIn();
			if (item.type == "GunsOne" ) {
				$('.conteudoItens').css('display', 'none');
				$('.conteudoItensTwo').css('display', 'flex');
			}
			if (item.type == "GunsTwo") {
				$('.conteudoItens').css('display', 'flex');
				$('.conteudoItensTwo').css('display', 'none');
			}
			updateChest();
		}

		if (item.hidemenu) {
			$('body').css('background-color', 'transparent')
			actionContainer.fadeOut();
		}
	});

	document.onkeyup = function(data) {
		if (data.which == 27) {
			if (actionContainer.is(":visible")) {
				sendData("ButtonClick", "fechar");
			}
		}
	};
	});

	function ResetMenu() {
	$("div").each(function(i, obj) {
		var element = $(this);

		if (element.attr("data-parent")) {
			element.hide();
		} else {
			element.show();
		}
	});
}

function init() {
	$("button").each(function(i, obj) {
		if ($(this).attr("data-action")) {
			$(this).click(function() {
				var data = $(this).data("action");
				sendData("ButtonClick", data);
			});
		}
	
		if ($(this).attr("data-sub")) {
		var menu = $(this).data("sub");
		var element = $("#" + menu);
	
		$(this).click(function() {
			element.show();
			$("#mainmenu").hide();
		});
	
		$(".subtop button, .back").click(function() {
			element.hide();
			$("#mainmenu").show();
		});
		}
	});
}

$(document).on('click','button',function(){
	if ($(this).attr("data-action")) {
		$(this).click(function() {
			var data = $(this).data("action");
			let item = $(this).attr('itemName');
			sendData("ButtonClick", data, item);
		});
	}
})
	
const sendData = (name, data, item) => {
	$.post("http://nav_teste/"+name,JSON.stringify(data),JSON.stringify(item),function(datab){});
}

$('.category_item').click(function() {
	let pegArma = $(this).attr('category');
	$('.item-item').css('transform', 'scale(0)');

	function hideArma() {
		$('.item-item').hide();
	}
	setTimeout(hideArma, 100);

	function showArma() {
		$('.item-item[category="' + pegArma + '"]').show();
		$('.item-item[category="' + pegArma + '"]').css('transform', 'scale(1)');
	}
	setTimeout(showArma, 100);
});

$('.category_item[category="all"]').click(function() {
	function showAll() {
		$('.item-item').show();
		$('.item-item').css('transform', 'scale(1)');
	}
	setTimeout(showAll, 100);
});

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

const updateChest = () => {
	$.post("http://nav_teste/requestChest",JSON.stringify({}),(data) => {
		const nameList = data.itens.sort((a,b) => (a.name > b.name) ? 1: -1);
		const nameListTwo = data.itensTwo.sort((a,b) => (a.name > b.name) ? 1: -1);
		$('.conteudoItens').html(`
			${nameList.map((item) => (`
				<div class='itemSessao' data-item-key='${item.anotherindex}'>
					<div class='item-info'>
						<div class='fotoItem'>
							<img src='http://192.99.251.232:3554/images/vrp_itens/${item.anotherindex}.png'>
						</div>
						<div class='menuItem'>
							<div class='nomeItem'>
								<p><b>${item.name}</b></p>
							</div>
							<div class='produzir'>
								<button data-action='${item.anotherindex}' itemName='${item.anotherindex}' class='menuoption'><b>MONTAR</b></button>
							</div>
						</div>
						<div class="ingredients">
							<div class='ingre'>
								<img src='http://192.99.251.232:3554/images/vrp_itens/${item.ingrOne}.png'>
								<div class='ingreAmount'>${formatarNumero(item.ingrOneAmount)}x</div>
							</div>
							<div class='ingre'>
								<img src='http://192.99.251.232:3554/images/vrp_itens/${item.ingrTwo}.png'>
								<div class='ingreAmount'>${formatarNumero(item.ingrTwoAmount)}x</div>
							</div>
							<div class='ingre'>
								<img src='http://192.99.251.232:3554/images/vrp_itens/${item.ingrThree}.png'>
								<div class='ingreAmount'>${formatarNumero(item.ingrThreeAmount)}x</div>
							</div>
							<div class='ingre'>
								<img src='http://192.99.251.232:3554/images/vrp_itens/${item.ingrFour}.png'>
								<div class='ingreAmount'>${formatarNumero(item.ingrFourAmount)}x</div>
							</div>
							<div class='ingre'>
								<img src='http://192.99.251.232:3554/images/vrp_itens/${item.ingrFive}.png'>
								<div class='ingreAmount'>${formatarNumero(item.ingrFiveAmount)}x</div>
							</div>
						</div>
					</div>
				</div>
			`)).join('')}

		`);
		$('.conteudoItensTwo').html(`
			${nameListTwo.map((item) => (`
				<div class='itemSessao' data-item-key='${item.anotherindex}'>
					<div class='item-info'>
						<div class='fotoItem'>
							<img src='http://192.99.251.232:3554/images/vrp_itens/${item.anotherindex}.png'>
						</div>
						<div class='menuItem'>
							<div class='nomeItem'>
								<p><b>${item.name}</b></p>
							</div>
							<div class='produzir'>
							<button data-action='${item.anotherindex}' itemName='${item.anotherindex}' class='menuoption'><b>MONTAR</b></button>
							</div>
						</div>
						<div class="ingredients">
							<div class='ingre'>
								<img src='http://192.99.251.232:3554/images/vrp_itens/${item.ingrOne}.png'>
								<div class='ingreAmount'>${formatarNumero(item.ingrOneAmount)}x</div>
							</div>
							<div class='ingre'>
								<img src='http://192.99.251.232:3554/images/vrp_itens/${item.ingrTwo}.png'>
								<div class='ingreAmount'>${formatarNumero(item.ingrTwoAmount)}x</div>
							</div>
							<div class='ingre'>
								<img src='http://192.99.251.232:3554/images/vrp_itens/${item.ingrThree}.png'>
								<div class='ingreAmount'>${formatarNumero(item.ingrThreeAmount)}x</div>
							</div>
							<div class='ingre'>
								<img src='http://192.99.251.232:3554/images/vrp_itens/${item.ingrFour}.png'>
								<div class='ingreAmount'>${formatarNumero(item.ingrFourAmount)}x</div>
							</div>
							<div class='ingre'>
								<img src='http://192.99.251.232:3554/images/vrp_itens/${item.ingrFive}.png'>
								<div class='ingreAmount'>${formatarNumero(item.ingrFiveAmount)}x</div>
							</div>
						</div>
					</div>
				</div>
			`)).join('')}

		`);
	});
}