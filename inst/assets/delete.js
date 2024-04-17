(() => {
  const dels = document.querySelectorAll(".predelete");

  if (!dels) return;

  let toDelete;
  for (let i = 0; i < dels.length; i++) {
    dels[i].addEventListener("click", () => {
      toDelete = i;
      document.querySelector("#deletemodal").classList.add("is-active");
    });
  }

  const cancel = document.querySelector("#deletecancel");

  if (!cancel) return;

  cancel.addEventListener("click", () => {
    document.querySelector("#deletemodal").classList.remove("is-active");
  });

  const confirm = document.querySelector("#deleteconfirm");

  confirm.addEventListener("click", () => {
    document.querySelectorAll(".realdelete")[toDelete].click();
  });
})();
