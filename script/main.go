package main
//----------
import (
    json     "encoding/json"
    ioutil   "io/ioutil"
    log      "log"
    http     "net/http"
    mux      "github.com/gorilla/mux"
    time     "time"
)

//----------
type property struct {
    IP_LISTENER     string `json:"IP_LISTENER"`    
    PORT_LISTENER   string `json:"PORT_LISTENER"`
    LAST_UPDATE     string `json:"LAST_UPDATE"`
}
type allProperties []property;

var properties = allProperties{
    {
        IP_LISTENER: "null",
        PORT_LISTENER: "null",
        LAST_UPDATE: "null",
    },
}

//----------
func getProperties(w http.ResponseWriter, r *http.Request) {
    json.NewEncoder(w).Encode(properties);
}
func updateProperties(w http.ResponseWriter, r *http.Request) {
    var updatedProperty property;
    reqBody,_ := ioutil.ReadAll(r.Body);
    json.Unmarshal(reqBody, &updatedProperty);
    currentTime := time.Now();    
    //----------
    for i, key := range properties {
        if len(updatedProperty.PORT_LISTENER) > 0 { key.PORT_LISTENER = updatedProperty.PORT_LISTENER; } else { key.PORT_LISTENER = key.PORT_LISTENER; }
        if len(updatedProperty.IP_LISTENER) > 0 { key.IP_LISTENER = updatedProperty.IP_LISTENER; } else { key.IP_LISTENER = key.IP_LISTENER; }        
        key.LAST_UPDATE = currentTime.String();
        properties = append(properties[:i], key);
        json.NewEncoder(w).Encode(key);
    }
}

//----------
func main() {
    router := mux.NewRouter().StrictSlash(true);
    router.HandleFunc("/", getProperties).Methods("GET");
    router.HandleFunc("/", updateProperties).Methods("PATCH");
    log.Fatal(http.ListenAndServe(":2080", router));
}