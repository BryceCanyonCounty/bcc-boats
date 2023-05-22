$('#creatormenu').fadeOut(0);

window.addEventListener('message', function(event) {
    const action    = event.data.action;
    const shopData  = event.data.shopData;
    const boatData = event.data.myBoatsData;

    if (action === "hide") {$("#creatormenu").fadeOut(1000);};
    if (action === "show") {$("#creatormenu").fadeIn(1000);};

    if (shopData) {
        for (const [index, table] of Object.entries(shopData)) {
            const boatType = table.boatType;
            if ($(`#page_shop .scroll-container .collapsible #${index}`).length <= 0) {
                $('#page_shop .scroll-container .collapsible').append(`
                    <li id="${index}">
                        <div class="collapsible-header col s12 panel ">
                            <div class="col s12 panel-title">
                                <h6 class="grey-text plus">${boatType}</h6>
                            </div>
                        </div>
                        <div class="collapsible-body item-bg"></div>
                    </li>
                `);
            };
            for (const [_, boatData] of Object.entries(table)) {
                if (_ != 'boatType') {
                    let ModelBoat;
                    const boatLabel = boatData.label;
                    const priceCash  = boatData.cashPrice;
                    const priceGold  = boatData.goldPrice;
                    $(`#page_shop .scroll-container .collapsible #${index} .collapsible-body`).append(`
                        <div id="${_}" onhover="loadBoat(this)" class="col s12 panel-shop item">
                            <div class="col s6 panel-col item">
                                <h6 class="grey-text-shop title">${boatLabel}</h6>
                            </div>          
                            <div class="buy-buttons">
                                <button class="btn-small"  onclick="BuyBoat('${_}', ${priceCash}, true)">
                                    <img src="img/money.png"><span class="boat-price">${priceCash}</span>
                                </button>                                  
                                <button class="btn-small right-btn"  onclick="BuyBoat('${_}', ${priceGold}, false)">                                                
                                    <img src="img/gold.png"><span class="boat-price">${priceGold}</span>
                                </button>                                          
                            </div>
                        </div>
                    `);
                    $(`#page_shop .scroll-container .collapsible #${index} .collapsible-body #${_}`).hover(function() {                       
                        $(this).click(function() {                        
                            $(ModelBoat).addClass("selected");
                            $('.selected').removeClass("selected"); 
                            ModelBoat = $(this).attr('id');                       
                            $(this).addClass('selected');
                            $.post('http://bcc-boats/LoadBoat', JSON.stringify({boatModel: $(this).attr('id')}));
                        });                       
                    }, function() {});
                };
            };
        };
        const location  = event.data.location;
        document.getElementById('shop_name').innerHTML = location;
    };
    if (boatData) {
        $('#page_myboats .scroll-container .collapsible').html('');
        $('.collapsible').collapsible();
        for (const [ind, tab] of Object.entries(boatData)) {
            const boatName = tab.name;
            const boatId = tab.id;
            const boatModel = tab.model;
            $('#page_myboats .scroll-container .collapsible').append(`
                <li>
                    <div id="${boatId}" class="collapsible-header col s12 panel">
                        <div class="col s12 panel-title">
                            <h6 class="grey-text plus">${boatName}</h6>
                        </div>
                    </div>
                    <div class="collapsible-body col s12 panel-myboat item">
                        <button class="col s4 panel-col item-myboat" onclick="Rename(${boatId})">Rename</button>
                        <button class="col s4 panel-col item-myboat" onclick="Launch(${boatId}, '${boatModel}', '${boatName}')">Launch</button>
                        <button class="col s4 panel-col item-myboat" onclick="Sell(${boatId}, '${boatName}')">Sell</button>
                    </div>
                </li>
            `);
            $(`#page_myboats .scroll-container .collapsible #${boatId}`).hover(function() {  
                $(this).click(function() {
                    $.post('http://bcc-boats/LoadMyBoat', JSON.stringify({ BoatId: boatId, BoatModel: boatModel}));
                });                         
            }, function() {});
        };
    };
});

function BuyBoat(modelB, price, isCash) {
    $('#page_myboats .scroll-container .collapsible').html('');
    $('#page_shop .scroll-container .collapsible').html('');
    $("#creatormenu").fadeOut(1000);
    if (isCash) {        
        $.post('http://bcc-boats/BuyBoat', JSON.stringify({ ModelB: modelB, Cash: price, IsCash: isCash }));
    } else {
        $.post('http://bcc-boats/BuyBoat', JSON.stringify({ ModelB: modelB, Gold: price, IsCash: isCash }));
    };
};

function Rename(boatId) {
    $('#page_myboats .scroll-container .collapsible').html('');
    $('#page_shop .scroll-container .collapsible').html('');
    $("#creatormenu").fadeOut(1000);
    $.post('http://bcc-boats/RenameBoat', JSON.stringify({BoatId: boatId}));
}

function Launch(boatId, boatModel, boatName) {    
    $.post('http://bcc-boats/LaunchData', JSON.stringify({ BoatId: boatId, BoatModel: boatModel, BoatName: boatName }));
    $('#page_myboats .scroll-container .collapsible').html('');
    $('#page_shop .scroll-container .collapsible').html('');
    $("#creatormenu").fadeOut(1000);
    CloseMenu()
};

function Sell(boatId, boatName) {    
    $.post('http://bcc-boats/SellBoat', JSON.stringify({ BoatId: boatId,  BoatName: boatName}));
    $('#page_myboats .scroll-container .collapsible').html('');
    $('#page_shop .scroll-container .collapsible').html('');
    $("#creatormenu").fadeOut(1000);
};

function Rotate(direction) {
    let rotateBoat = direction;
    $.post('http://bcc-boats/Rotate', JSON.stringify({ RotateBoat: rotateBoat }));
};

function CloseMenu() {
    $.post('http://bcc-boats/CloseMenu');
    $('#page_myboats .scroll-container .collapsible').html('');
    $('#page_shop .scroll-container .collapsible').html('');
    $("#creatormenu").fadeOut(1000);
    ResetMenu();
};

let currentPage = 'page_myboats';
function ResetMenu() {
    $(`#${currentPage}`).hide();
    currentPage = 'page_myboats';
    $('#page_myboats').show();
    $('.menu-selectb.active').removeClass('active');
    $('#button-myboats.menu-selectb').addClass('active');
};

$('.menu-selectb').on('click', function() {
    $(`#${currentPage}`).hide();
    currentPage = $(this).data('target');
    $(`#${currentPage}`).show();
    $('.menu-selectb.active').removeClass('active');
    $(this).addClass('active');
});
