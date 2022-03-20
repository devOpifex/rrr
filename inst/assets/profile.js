window.addEventListener('DOMContentLoaded', (event) => {
  var btns = document.getElementsByClassName('delete-url');

  Array.from(btns).forEach(function(btn) {
    btn.addEventListener('click', deleteURL);
  });
});

var deleteURL = function(event){
  Ambiorix.send(
    "delete-url",
    event.target.dataset.hash
  );

  event.target
    .closest('.shortened-url')
    .remove();
}
