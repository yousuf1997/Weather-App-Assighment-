/* Copyright 2019 Esri
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */


// You can run your app in Qt Creator by pressing Alt+Shift+R.
// Alternatively, you can run apps through UI using Tools > External > AppStudio > Run.
// AppStudio users frequently use the Ctrl+A and Ctrl+I commands to
// automatically indent the entirety of the .qml file.

import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.1
import QtPositioning 5.8
import QtLocation 5.9
import QtQuick 2.9


import ArcGIS.AppFramework 1.0
import ArcGIS.AppFramework.Controls 1.0
import Esri.ArcGISRuntime 100.2

App {
    id: app
    width: 400
    height: 640

    Rectangle {
        id: navbar
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
        }



        height: 50 * AppFramework.displayScaleFactor
        color: app.info.propertyValue("titleBackgroundColor", "black")
        Text {
            id: titleText
            anchors.centerIn: parent
            text: "My Weather App"
            color: app.info.propertyValue("titleTextColor", "white")
            font {
                pointSize: 18
            }
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            maximumLineCount: 2
            elide: Text.ElideRight
            horizontalAlignment: Text.AlignHCenter
             Component.onCompleted: updateList()
        }


               //Getting cordinates of the user
                PositionSource {
                  //  PositionSource.position.
                   // Component.onCompleted:
                    id: position1
                  // text1.text = "Component is completed"
                      onPositionChanged:{
                          var cordinates = position1.position.coordinate;
                           //titleText.text = cordinates.longitude + " , " + cordinates.latitude;
                           getWeatherData(cordinates.latitude,cordinates.longitude );
                      }
                }




    }
    //weather stuff
    Rectangle {
        id: current_city
        anchors {
            left: parent.left
            right: parent.right
            top: navbar.bottom
        }

        height: 80 * AppFramework.displayScaleFactor
        color: app.info.propertyValue("titleBackgroundColor", "grey")
        Text {
            id: city_name
            anchors.centerIn: parent
            text: "City Name"
            color: app.info.propertyValue("titleTextColor", "white")
            font {
                pointSize: 18
            }
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            maximumLineCount: 2
            elide: Text.ElideRight
            horizontalAlignment: Text.AlignHCenter
        }
        Text {
            id: current_weather
           // anchors.centerIn: parent
            anchors.top : city_name.bottom
            anchors.left: parent.left
            anchors.right: parent.right

            text: "Current Weather"
            color: app.info.propertyValue("titleTextColor", "white")
            font {
                pointSize: 14
            }
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            maximumLineCount: 2
            elide: Text.ElideRight
            horizontalAlignment: Text.AlignHCenter
        }
    }

    //list stuff

    ListModel {
        id: days
        ListElement {
            day: "Sunday"
            high_temp : "44"
            low_temp : "sss"
            humidity : "222"

        }
        ListElement {
            day: "Monday"
            high_temp : "44"
            low_temp : "sss"
            humidity : "222"
        }
        ListElement {
            day: "Tuesday"
            high_temp : "44"
            low_temp : "sss"
            humidity : "222"
        }
        ListElement {
            day: "Wednesday"
            high_temp : "44"
            low_temp : "sss"
            humidity : "222"
        }
        ListElement {
            day: "Thursday"
            high_temp : "44"
            low_temp : "sss"
            humidity : "222"
        }
        ListElement {
            day: "Friday"
            high_temp : "44"
            low_temp : "sss"
            humidity : "222"
        }
        ListElement {
            day: "Saturday"
            high_temp : "44"
            low_temp : "sss"
            humidity : "222"
        }


    }


    //customized list
    Rectangle {
        width: 250; height: 500
        //alighment
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: current_city.bottom

        Component {
            id: contactDelegate
            Item {
                width: 180; height: 70

                Column {
                    Text { text: '<b>Day:</b> ' + day }
                    Text { text: '<b>High Temp:</b> ' + high_temp }
                    Text { text: '<b>Low Temp:</b> ' + low_temp }
                    Text { text: '<b>Humidity :</b> ' + humidity }

                }
            }
        }

        ListView {
            anchors.fill: parent
            model: days
            delegate: contactDelegate
            highlight: Rectangle { color: "lightsteelblue"; radius: 5 }
         //   Component.onCompleted: updateList()
            focus: true
        }
    }
    //API to get the weather data using the cordinates
    //api.openweathermap.org/data/2.5/forecast?lat=35&lon=139&APPID=dba70a9c4c2aca0266c9a3a49b987a4f
    //API key: dba70a9c4c2aca0266c9a3a49b987a4f
    //"http://free.worldweatheronline.com/feed/weather.ashx?q=Jyv%c3%a4skyl%c3%a4,Finland&format=json&num_of_days=5&key=2d27bd6c4a274f31b0982928192308"

    function  getWeatherData(lat, longi){
       var req = new XMLHttpRequest();
         var weatherObject;
        var url =  "https://api.openweathermap.org/data/2.5/forecast?lat="+lat+"&lon="+longi+"&APPID=dba70a9c4c2aca0266c9a3a49b987a4f";
        req.open("GET", url, true);
        req.onreadystatechange = function() {
              weatherObject = JSON.parse(req.responseText);

            if (req.readyState !== 4) return;
            if (req.status !== 200) return;

            city_name.text = weatherObject.city["name"] + ", " + weatherObject.city["country"];
           //  days.setProperty(0, "high_temp", weatherObject.list[0].main.temp);
            updateListHelper(weatherObject);
          //  position1.stop();

        }
        req.send();
           //return weatherObject;
    }

    function updateList(){
        //First : Get the cordinates
        //Second: Check if the data is already cached in the storage with current date
        //Third :if the data is already cached, do not do api call
        //Fourth Just update the list
        position1.start();
     }

    function updateListHelper(weatherData){

        //need this array to order list of days
        var weeks = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday","Friday","Saturday"];
        //what day is today
        var date = new Date();
        var today = date.getDay();
        //current temperature
        current_weather.text = weeks[today] +", " + Math.round(convertToFarenheigt(weatherData.list[0].main.temp));

        //updating the List

        var day_index = today;
        var index = 0;

        while(index <= 6 ){
            if(day_index > 6) day_index = 0;
             days.setProperty(index, "high_temp", Math.round(convertToFarenheigt(weatherData.list[index].main.temp_max)));
             days.setProperty(index, "low_temp", Math.round(convertToFarenheigt(weatherData.list[index].main.temp_min)));
             days.setProperty(index, "humidity", Math.round(convertToFarenheigt(weatherData.list[index].main.humidity)));
             days.setProperty(index, "day", days[day_index]);

            day_index++;
            index++;
        }

      //  days.setProperty(0, "high_temp", weatherObject.list[0].main.temp);

       // position1.stop();
    }

    function convertToFarenheigt(kelvin){
        return (1.8 * (kelvin - 273)) + 32;
    }

}

