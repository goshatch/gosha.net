// toggle to switch classes between .light and .dark
// if no class is present (initial state), then assume current state based on system color scheme
// if system color scheme is not supported, then assume current state is light
//
// Source: https://stackoverflow.com/a/68824350/12288625

const toggleDarkMode = () => {
  if (document.documentElement.classList.contains("light")) {
    document.documentElement.classList.remove("light")
    document.documentElement.classList.add("dark")
  } else if (document.documentElement.classList.contains("dark")) {
    document.documentElement.classList.remove("dark")
    document.documentElement.classList.add("light")
  } else {
    if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) {
      document.documentElement.classList.add("light")
    } else {
      document.documentElement.classList.add("dark")
    }
  }
}

const daysOfWar = () => {
  const warStart = new Date('2022-02-24')
  const currentDate = new Date()

  return Math.round((currentDate-warStart)/(1000*60*60*24))
}

(function() {
  document.getElementById('war-days').innerHTML = `${daysOfWar()} days of war! `
})()
