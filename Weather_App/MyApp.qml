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
import ArcGIS.AppFramework.Sql 1.0
import ArcGIS.AppFramework.SecureStorage 1.0
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

        //Initialzing the database for local Storage
        FileFolder {
          id: fileFolder
          path: "~/ArcGIS/Data/Sql"
        }

        SqlDatabase {
          id: weather_database
          databaseName: fileFolder.filePath("weather_data.sqlite")
        }
       // Component.onCompleted: {
                   // initDataBase();
        //}




        //Getting cordinates of the user

            PositionSource {
                  //  PositionSource.position.
                   // Component.onCompleted:
                    id: position1
                  // text1.text = "Component is completed"
                      onPositionChanged:{
                           fileFolder.makeFolder();
                          var cordinates = position1.position.coordinate;

                          //changes the viewpoint of the map
                       //  point_builder.setXY(cordinates.longitude, cordinates.latitude);
                       //  mapView.setViewpoint(point_builder.geometry);

                           //titleText.text = cordinates.longitude + " , " + cordinates.latitude;
                                         //   maps.setViewpoint(cordinates.longitude,cordinates.latitude );

                                                 getWeatherData(cordinates.latitude,cordinates.longitude );
                                                 updateCachedList();

                      }

                }

            //}


    }
    //weather stuff
    Rectangle {
        id: current_city
        anchors {
            left: parent.left
            right: parent.right
            top: navbar.bottom
        }

        height: 120 * AppFramework.displayScaleFactor
        color: app.info.propertyValue("titleBackgroundColor", "grey")
        Button {
            id: city_name
            anchors.centerIn: parent

            text: "City Name"
     //       color: app.info.propertyValue("titleTextColor", "white")
            font {
                pointSize: 13
            }
            onClicked: {
                       if(mapView.visible){
                           listview.visible = true;
                           mapView.visible = false;
                           city_name.highlighted = false;
                       }else{

                           listview.visible = false;
                           mapView.visible = true;
                           mapView.locationDisplay.autoPanMode = Enums.LocationDisplayAutoPanModeCompassNavigation;
                           mapView.locationDisplay.start();
                           city_name.highlighted = true;

                       }

            }

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
            day: "No DAy"
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



        MapView {
            id: mapView
            anchors.fill: parent
            visible: false
            Map {
                BasemapImagery {}


            }
                locationDisplay{
                    positionSource: PositionSource {
                        onPositionChanged: {

                        }
                    }
                }

        }
        // Create the intial Viewpoint




        ListView {
            anchors.fill: parent
            model: days
            id:listview
            visible: true
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

        // req.status
            req.onreadystatechange = function() {
              weatherObject = JSON.parse(req.responseText);
            if (req.readyState !== 4 && req.readyState !== 200){
                        return;
                }
             city_name.text = weatherObject.city["name"] + ", " + weatherObject.city["country"];
            SecureStorage.setValue("current_City", weatherObject.city["name"] + ", " +  weatherObject.city["country"]);
            updateListHelper(weatherObject);

            }
        req.send();
       //
        position1.stop();

    }

    function initDataBase(){
        weather_database.open();
        var query1 = "DROP TABLE IF EXISTS WEATHER_DATA;";
        var query2 = "CREATE TABLE WEATHER_DATA(
                    Day TEXT,
                    LowTemp INTEGER,
                    HighTemp INTEGER,
                    Humidity INTEGER
                    )";
        weather_database.query("DROP TABLE IF EXISTS WEATHER_DATA");
        weather_database.query(query2);
    //    weather_database.close();
        // titleText.text = "Database is created";
    }

    function insertData(day ,low_temp, high_temp, humidity){
     //   weather_database.open();
        var statement = "INSERT INTO WEATHER_DATA VALUES
        ('" + day + "' ," + low_temp + " ," + high_temp + " ," + humidity + ")";

        weather_database.query(statement);

        // city_name.text = "Updating the data "  ;
    }

    function updateList(){
        //First : Get the cordinates
        //Second: Check if the data is already cached in the storage with current date
        //Third :if the data is already cached, do not do api call
        //Fourth Just update the list

        //check if internet exits


        position1.start();
     }

    function updateListHelper(weatherData){

        initDataBase();
         //set bool == true

        //urrent_weather.text = "Hello";
        //need this array to order list of days
        var weeks = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday","Friday","Saturday"];
        //what day is today
        var date = new Date();
        var today = date.getDay();
        var temp_ =  Math.round(convertToFarenheigt(weatherData.list[0].main.temp_max));
        //current temperature

      current_weather.text = weeks[today] +", " + temp_ +  "° F";

        //updating the List

        var day_index = today;
        var index = 0;

        while(index <= 6 ){
            if(day_index > 6) day_index = 0;
             days.setProperty(index, "high_temp", Math.round(convertToFarenheigt(weatherData.list[index].main.temp_max)) +  "° F");
             days.setProperty(index, "low_temp", Math.round(convertToFarenheigt(weatherData.list[index].main.temp_min)) +  "° F");
             days.setProperty(index, "humidity", Math.round(weatherData.list[index].main.humidity) + "%");
             days.setProperty(index, "day", weeks[day_index]);

            //insert into the database
            insertData(weeks[day_index], Math.round(convertToFarenheigt(weatherData.list[index].main.temp_min) +  "° F"),
                       Math.round(convertToFarenheigt(weatherData.list[index].main.temp_max) +  "° F"),
                       Math.round(weatherData.list[index].main.humidity) + "%");

            day_index++;
            index++;
        }

    }
    function updateCachedList(){
            weather_database.open();
         var result = weather_database.query("SELECT * FROM WEATHER_DATA");
         var data = result.first();
        city_name.text = SecureStorage.value("current_City");
     //   city_name.text = data;
        var weather = false;
        var index = 0;
         while (data) {
             var dataJson = JSON.stringify(result.values);
             var convert = JSON.parse(dataJson);
             //city_name.text = convert.Day;
              if(!weather){
                  current_weather.text = convert.Day + ", " +  convert.HighTemp + "° F";
                  weather = true;
              }

             days.setProperty(index, "high_temp", convert.HighTemp);
             days.setProperty(index, "low_temp",  convert.LowTemp);
             days.setProperty(index, "humidity",  convert.Humidity);
             days.setProperty(index, "day",  convert.Day);

             index++;
          data = result.next();
         }
         result.finish();

      //  weather_database.close();
    }

    function convertToFarenheigt(kelvin){
        return (1.8 * (kelvin - 273)) + 32;
    }



}


