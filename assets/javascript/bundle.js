const daysOfWar = () => {
  const warStart = new Date('2022-02-24')
  const currentDate = new Date()

  return Math.round((currentDate - warStart) / (1000 * 60 * 60 * 24))
}

(function() {
  document.getElementById('war-days').innerHTML = `${daysOfWar()} days of war! `
})()
