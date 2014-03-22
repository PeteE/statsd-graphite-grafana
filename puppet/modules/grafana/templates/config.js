define(['settings'],
function (Settings) {
  "use strict";
 
  return new Settings({
    elasticsearch: "http://"+window.location.hostname+":9200",
    graphiteUrl: "http://<%= @graphite_hostname %>",
    default_route: '/dashboard/file/default.json',
    timezoneOffset: null,
    grafana_index: "grafana-dash",
    panel_names: [
      'text',
      'graphite'
    ]
  });
});
