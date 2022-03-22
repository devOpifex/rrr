let el, ctx, chart;
let config = {
  type: 'bar',
  data: {
    labels: [],
    datasets: [{
      label: '# clicks',
      data: []
    }]
  },
  options: {
    responsive: true,
    scales: {
      y: {
        beginAtZero: true
      },
      x: {
        type: 'time',
        grid: {
          display: false
        }
      }
    },
    plugins: {
      legend: {
        display: false
      }
    }
  }
};

document.addEventListener('DOMContentLoaded', () => {
  el = document.getElementById('plot');
  ctx = el.getContext('2d');
  chart = new Chart(ctx, config); 

  var btns = document.getElementsByClassName('get-data');
  Array.from(btns).forEach(function(btn) {
    btn.addEventListener('click', displayData);
  });   
});

const displayData = (e) => {
  document.getElementById('plot').style.display = "block";
  
  fetch(`/profile/data?hash=${encodeURIComponent(e.target.dataset.hash)}`)
    .then(response => response.json())
    .then(data => {
      removeData(chart);
      let dates = data.map(el => el.date);
      let values = data.map(el => el.count);
      
      addData(chart, dates, values);
    })
    .catch(error => console.error(error));
}

function addData(chart, label, data) {
  chart.data.labels = label;
  chart.data.datasets[0].data = data;
  chart.data.datasets[0].backgroundColor = data.map(() => "rgba(94, 96, 206, .8)")
  chart.update();
}

function removeData(chart) {
  chart.data.labels.pop();
  chart.data.datasets.forEach((dataset) => {
      dataset.data.pop();
  });
}
