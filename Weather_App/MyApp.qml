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
            weather: "50 Degree"
        }
        ListElement {
            day: "Monday"
            weather: "50 Degree"
        }
        ListElement {
            day: "Tuesday"
            weather: "56 Degree"
        }
        ListElement {
            day: "Wednesday"
            weather: "56 Degree"
        }
        ListElement {
            day: "Thursday"
            weather: "56 Degree"
        }
        ListElement {
            day: "Friday"
            weather: "56 Degree"
        }

    }


    //customized list
    Rectangle {
        width: 180; height: 200
        //alighment
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: current_city.bottom

        Component {
            id: contactDelegate
            Item {
                width: 180; height: 40
                Column {
                    Text { text: '<b>Day:</b> ' + day }
                    Text { text: '<b>Weather:</b> ' + weather }
                }
            }
        }

        ListView {
            anchors.fill: parent
            model: days
            delegate: contactDelegate
            highlight: Rectangle { color: "lightsteelblue"; radius: 5 }

            focus: true
        }
    }

}

