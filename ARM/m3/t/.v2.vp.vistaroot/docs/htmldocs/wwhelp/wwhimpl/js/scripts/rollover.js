// Rollover Image Library
//

// Image files should be named according to the following convention:
//   Original:  foo.png
//   Hover:     foo_h.png
//   Disabled:  foo_x.png


var BTN_PREFIX = "btn_";  // id prefix for all button links (e.g <a id="btn_foo">)
var IMG_PREFIX = "img_";  // name prefix assigned to button images (e.g. img.name = "img_foo";)

// disbles link based on containing element and name
//
function disableLink (elem,name) {
	if (typeof(elem) == 'string') elem = document.getElementById(elem);
	if (elem == null) return;
	if (typeof(name) == 'string') link = document.getElementById(BTN_PREFIX+name);
	if (link == null) return;
	enableRolloverImg(elem,name,false);
	if (link.onclick && link.onclick != cancelLink ) {
		link.oldOnClick = link.onclick;
	}
	link.onclick = cancelLink;
	if (link.style) {
		link.style.cursor = 'default';
	}
}
// enables link based on containing element and name
//
function enableLink (elem,name) {
	if (typeof(elem) == 'string') elem = document.getElementById(elem);
	if (elem == null) return;
	if (typeof(name) == 'string') link = document.getElementById(BTN_PREFIX+name);
	if (link == null) return;
	enableRolloverImg(elem,name,true);
	link.onclick = link.oldOnClick ? link.oldOnClick : null;
	if (link.style) {
		link.style.cursor =
    	  document.all ? 'hand' : 'pointer';
 	}
}
// toggles link between enabled <-> disabled
//
function toggleLink (elem,name) {
	if (typeof(elem) == 'string') elem = document.getElementById(elem);
	if (elem == null) return;
	if (typeof(name) == 'string') link = document.getElementById(BTN_PREFIX+name);
	if (link == null) return;
	if (link.disabled) {
		enableLink (elem,name)
	} else {
		disableLink (elem,name);
	}
	link.disabled = !link.disabled;
}
function cancelLink () { return false; }


// Enable/disable rollover image
//
function enableRolloverImg(elem,name,enable) {
	if (typeof(elem) == 'string') elem = document.getElementById(elem);
	if (elem == null) return;
	if (typeof(enable) != 'boolean') enable = true;
	imgList = elem.getElementsByTagName('img');
	var image = null;
	for (var i=0; img = imgList[i]; i++) {
		if (img.rolloverSet && img.name == IMG_PREFIX + name ) {
		    img.rollover = enable;
		    img.src = (enable) ? img.outSRC : img.disableSRC;
		    return;
		}
	}
}


// Initializes rollover images (should be called after the body is loaded)
//
function prepareImageSwap(elem,mouseOver,mouseOutRestore,mouseDown,mouseUpRestore,mouseOut,mouseUp) {
//Do not delete these comments.
//Non-Obtrusive Image Swap Script by Hesido.com
//V1.1
//Attribution required on all accounts
	if (typeof(elem) == 'string') elem = document.getElementById(elem);
	if (elem == null) return;
//	var regg = /(.*)(_nm\.)([^\.]{3,4})$/
	var regg = /^(.*?)([^\/]*)\.([^\.]{3,4})$/
	var prel = new Array(), img, imgList, imgsrc, mtchd;
	imgList = elem.getElementsByTagName('img');

	for (var i=0; img = imgList[i]; i++) {
		if (!img.rolloverSet && img.src.match(regg)) {
			mtchd = img.src.match(regg);
			img.hoverSRC = mtchd[1]+mtchd[2]+'_h.'+ mtchd[3];
			img.outSRC = img.src;
			img.disableSRC = mtchd[1]+mtchd[2]+'_x.' + mtchd[3];
			img.name = IMG_PREFIX + mtchd[2];
			if (typeof(mouseOver) != 'undefined') {
				img.hoverSRC = (mouseOver) ? mtchd[1]+mtchd[2]+'_h.'+ mtchd[3] : false;
				img.outSRC = (mouseOut) ? mtchd[1]+mtchd[2]+'_ou.'+ mtchd[3] : (mouseOver && mouseOutRestore) ? img.src : false;
				img.mdownSRC = (mouseDown) ? mtchd[1]+mtchd[2]+'_md.' + mtchd[3] : false;
				img.mupSRC = (mouseUp) ? mtchd[1]+mtchd[2]+'_mu.' + mtchd[3] : (mouseOver && mouseDown && mouseUpRestore) ? img.hoverSRC : (mouseDown && mouseUpRestore) ? img.src : false;
				}
			if (img.hoverSRC) {preLoadImg(img.hoverSRC); img.onmouseover = imgHoverSwap;}
			if (img.outSRC) {preLoadImg(img.outSRC); img.onmouseout = imgOutSwap;}
			if (img.mdownSRC) {preLoadImg(img.mdownSRC); img.onmousedown = imgMouseDownSwap;}
			if (img.mupSRC) {preLoadImg(img.mupSRC); img.onmouseup = imgMouseUpSwap;}
			if (img.disableSRC) {preLoadImg(img.disableSRC);}
			img.rollover = true;
			img.rolloverSet = true;
		}
	}

	function preLoadImg(imgSrc) {
		prel[prel.length] = new Image(); prel[prel.length-1].src = imgSrc;
	}

}

function imgHoverSwap() { if (this.rollover) {this.src = this.hoverSRC;} }
function imgOutSwap() { if (this.rollover) {this.src = this.outSRC;} }
function imgMouseDownSwap() { if (this.rollover) {this.src = this.mdownSRC;} }
function imgMouseUpSwap() { if (this.rollover) {this.src = this.mupSRC;} }

