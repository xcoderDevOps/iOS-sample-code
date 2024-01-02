

import Foundation


var startAddress = AddressDetail()
var endAddress = AddressDetail()

struct AddressDetail {
    var address = ""
    var stateName = ""
    var country = ""
    var lat = ""
    var long = ""
    var locationType = LocationTypeData()
}


struct DistanceDateTime
{
    var truckType = TruckTypeData()
    var serviceType = ServiceTypeData()
    var PickupDate = ""
    var distance = ""
    var administrativeArea = ""
    var totalPallet = ""
    var CBM = ""
    var HS = ""
    var Commodity = ""
    var actualTonnge = ""
    var isFargile = false
    var isExpress = false
    var noOfContainer = 0.0
    var containerHeight = ""
    var extraInstruction = ""
    var expressDate = ""
    var deliverItem = ""
    var cars = ""
    var liter = ""
    var cubicMeter = ""
    var kg = ""
    var IsCrossBorder = false
}

var distanceDateTime = DistanceDateTime()

enum JobStatus : Int {
    case QuoteRequest = 1
    case QuoteGeneration = 2
    case QuoteAccepted = 3
    case JobStarted = 4
    case ClearanceInProgress = 5
    case TruckAssigned = 6
    case TruckEnroute = 7
    case ArrivedAtDestination = 8
    case ArrivedAtDropOff = 9
    case JobCompleted = 10
    case Cancelled = 11
    case NewJobReturn = 18
    case OngoingJobReturn = 19
    case CompletedJobReturn = 20
}
