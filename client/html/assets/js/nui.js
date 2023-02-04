function postData(action, data) {
    fetch(`https://${GetParentResourceName()}/${action}`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify(data)
    }).catch(() => {
        return;
    });
}
    

function toggleNui(display) {
    if (display) {
        $('#empire').show();
    } else {
        $('#empire').fadeOut();
    }
}

$(function () {
    jQuery.migrateMute = true;

	toggleNui(false);
	
    window.addEventListener('message', function(event) {      
        //if (event.data.toggleMenu != null) {
            toggleNui(event.data.toggleMenu);
        //}
        
        if (event.data.syncData != null) {
            toggleNui(true);
            let clientData = event.data.syncData;
            
            document.getElementById("cardNumber").innerHTML = getFormattedCardNumber(clientData.cardNumber)
            document.getElementById("cardOwner").innerHTML = clientData.firstName + " " + clientData.lastName;
            document.getElementById("walletBalance").innerHTML = 'KONTOSTAND: <a style="color: #FF9B0F;">' + new Intl.NumberFormat('de-DE').format(clientData.walletAmount) + "$</a>";
        }
    });
    
    $(".interactionButton").click(function () {
        var interaction = $(this).attr('id').toLowerCase();
        
        if (interaction != "transfer") {    
            let amount = document.getElementById(interaction + "Amount").value;
            if (amount == null || amount == 0) return;
            
            postData('handleInteraction', {
                interaction: interaction,
                amount: amount
            });
        } else {
            let amount = document.getElementById("transferAmount").value;
            let id     = document.getElementById("transferId").value;
            
            if (amount == null || amount == 0) return;
            if (id     == null || id     == 0) return;
            
            postData('handleTransfer', {
                amount: amount,
                id: id
            });
        }
        document.getElementById('transferAmount').value = '';
        document.getElementById('transferId').value = '';
        document.getElementById('withdrawAmount').value = '';
        document.getElementById('depositAmount').value = '';

        postData('toggleFocus', {});
        toggleNui(false);
    });

    function getFormattedCardNumber(cardNumber) {
        if (cardNumber == null) return '1234 1234 1234 1234';
        return cardNumber.slice(0, 4) +' ' + cardNumber.slice(4, 8) + ' ' + cardNumber.slice(8, 12) + ' ' + cardNumber.slice(12, 16);
    }
    
    document.onkeydown = function(evt) {
        evt = evt || window.event;
        var isEscape = false;
    
        if ("key" in evt) {
            isEscape = (evt.key === "Escape" || evt.key === "Esc");
        } else {
            isEscape = (evt.keyCode === 27);
        }
    
        if (isEscape) {
            postData('toggleFocus', {})
            document.getElementById('transferAmount').value = '';
            document.getElementById('transferId').value = '';
            document.getElementById('withdrawAmount').value = '';
            document.getElementById('depositAmount').value = '';
            toggleNui(false)
        }
    };
});

