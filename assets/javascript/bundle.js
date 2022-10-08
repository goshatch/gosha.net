const setTheme = (lightOrDark) => {
  if (lightOrDark == 'light') {
    document.documentElement.classList.remove('dark')
    document.documentElement.classList.add('light')
  } else {
    document.documentElement.classList.remove('light')
    document.documentElement.classList.add('dark')
  }
  localStorage.setItem('color-theme', lightOrDark)
}

const setInitialTheme = () => {
  let theme = localStorage.getItem('color-theme');
  if (!theme) {
    if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) {
      theme = 'dark'
    }
  }
  setTheme(theme || 'light')
}

const toggleTheme = () => {
  if (document.documentElement.classList.contains("light")) {
    setTheme('dark')
  } else if (document.documentElement.classList.contains("dark")) {
    setTheme('light')
  }
}

const daysOfWar = () => {
  const warStart = new Date('2022-02-24')
  const currentDate = new Date()

  return Math.round((currentDate - warStart) / (1000 * 60 * 60 * 24))
}

(function() {
  setInitialTheme()
  document.getElementById('war-days').innerHTML = `${daysOfWar()} days of war! `
})()
