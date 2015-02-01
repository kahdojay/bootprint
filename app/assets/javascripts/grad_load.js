   // This example displays a marker at the center of Australia.
    // When the user clicks the marker, an info window opens.
console.log('grad file loaded')
    function initialize() {
      var myLatlng = new google.maps.LatLng(40.7048872,-74.0123737);
      var mapOptions = {
        zoom: 3,
        center: myLatlng
      };

      window.map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);
    }

    google.maps.event.addDomListener(window, 'load', initialize);

    $(document).ready(function(){
      $.ajax({
        type: "GET",
        url: "/graduates"
      }).done(function(response) {
        var infoBoxes = []

        response.forEach(function(graduate) {
          var ll = new google.maps.LatLng((parseFloat(graduate.latitude)), (parseFloat(graduate.longitude)))
          var marker = new google.maps.Marker({
            position: ll,
            map: window.map
          })

          var contentString = "<p>" + graduate.name + "</p><p>" + graduate.current_location + "</p><p>" + graduate.current_employer + "</p>" + "<a href=" + graduate.linkedin_url + ">LinkedIn</a></p>"
          var infoWindow = new google.maps.InfoWindow({
              content: contentString
          });

          infoBoxes.push(infoWindow)

          google.maps.event.addListener(marker, 'click', function() {
            infoBoxes.forEach(function(infoBox) {
              infoBox.close()
            })
            infoWindow.open(window.map,marker);
          });
        })
      })
    })