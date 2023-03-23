function validate(form) {
    // form1 has 7 dials. Any combination is valid
    // form2 has a text field which must have exactly 7 letters
    //     <input name=word type=text size=15 maxlength=7>
    // form3 goes to a random planet and has no inputs
    //
    // Any submission of forms 1 & 3 is valid.
    // If the word in form2 is invalid, KoL will reject it.
    //
    // We don't want to play the sound unless KoL will open the gate.
    var element = form.elements['word'];
    if (element) {
	var word = element.value;
	var ok = /^[a-zA-Z]{7}$/.test(word);
	if (!ok) {
	    alert("Thou must provide seven letters, no fewer, and no more, and nothing but letters.");
	    return false;
	}
    }
    return true;
}

function play_element(source) {
    return new Promise((resolve, reject) => {
	var audio = new Audio(source);
	audio.onended = function() {
	    resolve(true);
	};
	audio.play();
    });
}

function playSound(id) {
    var form = document.forms[id];

    if (!validate(form)) {
	return;
    }

    play_element("/images/spacegate_activate.mp3")
	.then((result) => {
	    if (result) {
		form.submit();
	    }
	})
	.catch(() => {
	});
}

function addPlaySoundSubmitListener(id) {
    var form = document.forms[id];
    form.addEventListener('submit', (e) => {
	e.preventDefault();
	playSound(id);
    });
}
