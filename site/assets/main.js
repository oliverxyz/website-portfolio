// Fades sections in once on scroll. Without JS everything is simply visible.
const items = document.querySelectorAll(".reveal");

if ("IntersectionObserver" in window && !matchMedia("(prefers-reduced-motion: reduce)").matches) {
  document.documentElement.classList.add("js");
  const observer = new IntersectionObserver((entries) => {
    for (const entry of entries) {
      if (entry.isIntersecting) {
        entry.target.classList.add("is-visible");
        observer.unobserve(entry.target);
      }
    }
  }, { rootMargin: "0px 0px -5% 0px" });
  items.forEach((item) => observer.observe(item));
}
