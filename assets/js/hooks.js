let Hooks = {}

Hooks.CopyToClipboard = {
  mounted() {
    this.el.addEventListener("click", () => {
      const text = this.el.dataset.text
      navigator.clipboard.writeText(text)
        .then(() => console.log("Скопировано:", text))
        .catch(err => console.error("Ошибка копирования:", err))
    })
  }
}

export default Hooks
