(() => {
  const del = document.querySelector("#predelete");

  if (!del) return;

  del.addEventListener("click", () => {
    document.querySelector("#deletemodal").classList.add("is-active");
  });

  const cancel = document.querySelector("#deletecancel");

  cancel.addEventListener("click", () => {
    document.querySelector("#deletemodal").classList.remove("is-active");
  });

  const confirm = document.querySelector("#deleteconfirm");

  confirm.addEventListener("click", () => {
    document.querySelector("#deletemodal").classList.remove("is-active");
    document.querySelector("#delete").click();
  });
})();
