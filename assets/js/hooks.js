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

Hooks.InfiniteScroll = {
  mounted() {
    let observer = new IntersectionObserver(entries => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          this.pushEvent("load-more")
        }
      })
    })

    observer.observe(this.el)
  }
}


export default Hooks
