
import Foundation


enum popUpMessage : String {
    case someWrong          = "Something went wrong. Please try again later"
    case emptyString        = "Please fill in all the fields"
    case emptyFullName      = "Please enter your full name"
    case emptyPassword      = "Please enter a password"
    case emptyCountry       = "Please select country name"
    case orginasitionEmpty  = "Please select organisation"
    case PasswordValid      = "Password must be between 6 and 16 characters"
    case UserValid          = "Username must be between 3 and 15 characters"
    case PasswrordValid     = "Please enter atleast one digit and one special character for your password in new password"
    case EmailValid         = "Please enter a valid email"
    case PhoneValid         = "Please enter a valid mobile number"
    case AlreadyExistsUser  = "This username is already registered"
    case emptyEmailId       = "Please enter your email"
    case emptyUserName      = "Please enter your username"
    case ConPassword        = "Please ensure password and confirmation password match"
    case currentPass        = "Please enter a valid password"
    case ValidPasscode      = "Please enter a valid OTP"
    case emptyGroupName     = "Please enter a group name"
    case AtLeastOneSelect   = "Please select atleast one member for the group"
    case DeleteAcc          = "Are you sure you want to delete this account?"
    case EmptyCurrentPass   = "Please enter your current password"
    case EmptyNewPass       = "Please enter a new password"
    case EmptyConfirmPass   = "Please confirm the new password"
    case NoInternet         = "The system is currently experiencing networking issues"
    case EmptyTag           = "Please enter atleast one tag or select a location"
    case DeleteChannel      = "Are you sure you want to delete the group?"
    case LeaveGroup         = "Are you sure you want to leave the group?"
    case DeleteMedia        = "Are you sure you want to delete this photo / video?"
    case mDeleteMedia       = "Are you sure you want to delete the selected photos / videos?"
    case clearNotif         = "Are you sure you want to clear all notifications?"
    case FirstTagMessage    = "Enter multiple tags separated by a comma (,)"
    case AdminDeletePhoto   = "Delete this picture permanently?\nThis picture will be deleted for all members as well"
    case AdminDeleteVideo   = "Delete this video permanently?\nThis video will be deleted for all members as well"
    case userDeletePhoto    = "Delete this picture permanently?"
    case userDeleteVideo    = "Delete this video permanently?"
    case DeleteCaseGroup    = "Group can only be deleted if there are no active members"
    case FileNotExistinAWS  = "Video file is no longer exist in the cloud"
    case largeVideoFile     = "Video duration should not exceed 30 seconds."
    case logoutStr          = "Are you sure you want to Logout?"
}


var eventTypeArray = ["Alarm Out", "Alarm In", "Alarm Acknowledged", "Low Battery", "Connection Lost", "No Alarm", "Max Alarm Out", "Min Alarm Out", "Max Alarm In", "Min Alarm In", "Connection Restored", "Settings Changed", "Device Chec"]
    
var arrayTimeZone = [
    "(UTC - 12:00) International Date Line West",
    "(UTC-11:00) Coordinated Universal Time-11",
    "(UTC-10:00) Hawaii",
    "(UTC-09:00) Alaska",
    "(UTC-08:00) Baja California",
    "(UTC-08:00) Pacific Time (US & Canada)",
    "(UTC-07:00) Arizona",
    "(UTC-07:00) Chihuahua, La Paz, Mazatlan",
    "(UTC-07:00) Mountain Time (US & Canada)",
    "(UTC-06:00) Central America",
    "(UTC-06:00) Central Time (US & Canada)",
    "(UTC-06:00) Guadalajara, Mexico City, Monterrey",
    "(UTC-06:00) Saskatchewan",
    "(UTC-05:00) Bogota, Lima, Quito, Rio Branco",
    "(UTC-05:00) Chetumal",
    "(UTC-05:00) Eastern Time (US & Canada)",
    "(UTC-05:00) Indiana (East)",
    "(UTC-04:30) Caracas",
    "(UTC-04:00) Asuncion",
    "(UTC-04:00) Atlantic Time (Canada)",
    "(UTC-04:00) Cuiaba",
    "(UTC-04:00) Georgetown, La Paz, Manaus, San Juan",
    "(UTC-03:30) Newfoundland",
    "(UTC-03:00) Brasilia",
    "(UTC-03:00) Buenos Aires",
    "(UTC-03:00) Cayenne, Fortaleza",
    "(UTC-03:00) Greenland",
    "(UTC-03:00) Montevideo",
    "(UTC-03:00) Salvador",
    "(UTC-03:00) Santiago",
    "(UTC-02:00) Coordinated Universal Time-02",
    "(UTC-02:00) Mid-Atlantic - Old",
    "(UTC-01:00) Azores",
    "(UTC-01:00) Cabo Verde Is.",
    "(UTC) Casablanca",
    "(UTC) Coordinated Universal Time",
    "(UTC) Dublin, Edinburgh, Lisbon, London",
    "(UTC) Monrovia, Reykjavik",
    "(UTC+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna",
    "(UTC+01:00) Belgrade, Bratislava, Budapest, Ljubljana, Prague",
    "(UTC+01:00) Brussels, Copenhagen, Madrid, Paris",
    "(UTC+01:00) Sarajevo, Skopje, Warsaw, Zagreb",
    "(UTC+01:00) West Central Africa",
    "(UTC+01:00) Windhoek",
    "(UTC+02:00) Amman",
    "(UTC+02:00) Athens, Bucharest",
    "(UTC+02:00) Beirut",
    "(UTC+02:00) Cairo",
    "(UTC+02:00) Damascus",
    "(UTC+02:00) E. Europe",
    "(UTC+02:00) Harare, Pretoria",
    "(UTC+02:00) Helsinki, Kyiv, Riga, Sofia, Tallinn, Vilnius",
    "(UTC+02:00) Istanbul",
    "(UTC+02:00) Jerusalem",
    "(UTC+02:00) Kaliningrad (RTZ 1)",
    "(UTC+02:00) Tripoli",
    "(UTC+03:00) Baghdad",
    "(UTC+03:00) Kuwait, Riyadh",
    "(UTC+03:00) Minsk",
    "(UTC+03:00) Moscow, St. Petersburg, Volgograd (RTZ 2)",
    "(UTC+03:00) Nairobi",
    "(UTC+03:30) Tehran",
    "(UTC+04:00) Abu Dhabi, Muscat",
    "(UTC+04:00) Baku",
    "(UTC+04:00) Izhevsk, Samara (RTZ 3)",
    "(UTC+04:00) Port Louis",
    "(UTC+04:00) Tbilisi",
    "(UTC+04:00) Yerevan",
    "(UTC+04:30) Kabul",
    "(UTC+05:00) Ashgabat, Tashkent",
    "(UTC+05:00) Ekaterinburg (RTZ 4)",
    "(UTC+05:00) Islamabad, Karachi",
    "(UTC+05:30) Chennai, Kolkata, Mumbai, New Delhi",
    "(UTC+05:30) Sri Jayawardenepura",
    "(UTC+05:45) Kathmandu",
    "(UTC+06:00) Astana",
    "(UTC+06:00) Dhaka",
    "(UTC+06:00) Novosibirsk (RTZ 5)",
    "(UTC+06:30) Yangon (Rangoon)",
    "(UTC+07:00) Bangkok, Hanoi, Jakarta",
    "(UTC+07:00) Krasnoyarsk (RTZ 6)",
    "(UTC+08:00) Beijing, Chongqing, Hong Kong, Urumqi",
    "(UTC+08:00) Irkutsk (RTZ 7)",
    "(UTC+08:00) Kuala Lumpur, Singapore",
    "(UTC+08:00) Perth",
    "(UTC+08:00) Taipei",
    "(UTC+08:00) Ulaanbaatar",
    "(UTC+09:00) Osaka, Sapporo, Tokyo",
    "(UTC+09:00) Seoul",
    "(UTC+09:00) Yakutsk (RTZ 8)",
    "(UTC+09:30) Adelaide",
    "(UTC+09:30) Darwin",
    "(UTC+10:00) Brisbane",
    "(UTC+10:00) Canberra, Melbourne, Sydney",
    "(UTC+10:00) Guam, Port Moresby",
    "(UTC+10:00) Hobart",
    "(UTC+10:00) Magadan",
    "(UTC+10:00) Vladivostok, Magadan (RTZ 9)",
    "(UTC+11:00) Chokurdakh (RTZ 10)",
    "(UTC+11:00) Solomon Is., New Caledonia",
    "(UTC+12:00) Anadyr, Petropavlovsk-Kamchatsky (RTZ 11)",
    "(UTC+12:00) Auckland, Wellington",
    "(UTC+12:00) Coordinated Universal Time+12",
    "(UTC+12:00) Fiji",
    "(UTC+12:00) Petropavlovsk-Kamchatsky - Old",
    "(UTC+13:00) Nuku'alofa",
    "(UTC+13:00) Samoa",
    "(UTC+14:00) Kiritimati Island",
  ]
