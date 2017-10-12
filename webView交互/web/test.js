
function changeView (str) {
    element= document.getElementById("test")
    element.innerHTML = str;
    element.style.color = "black"
    element.style.background = "#ffff00"
}

function btnClick(){
    window.webkit.messageHandlers.viewChange.postMessage({methodName:"labelChange:",canshu:"canshu1"});
}
function alertBtnClick(){

    alert("hello");
}
