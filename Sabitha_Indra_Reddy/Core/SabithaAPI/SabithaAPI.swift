//
//  SabithaAPI.swift
//  Sabitha_Indra_Reddy
//
//  Created by Aditya Bonthu on 28/04/18.
//  Copyright © 2018 Aditya Bonthu. All rights reserved.
//

import Foundation
import Moya

enum SabithaAPI {
    case deviceTokenRegister(deviceToken: String, deviceID: String, deviceType: String)
    case registeration(mobileNumber: String)
    case otpVerify(mobilenumber: String, otp: String)
    case ValidateUser()
    
    case feedData(page: Int)
    
    // Other Base API's
    case registerPetition(gtype: String, complaint: String, grievanceDetails: String, uploadedImage1: String, uploadedImage2: String, uploadedImage3: String)
    case Grievancetypes()
    case complaints(id: String)
    case viewStatusofPetition(petitioncode: String)
    case getTicketsList()

    case surveyData(page: Int)
    case surveyDetailData(surveyid: String)
    case submitSurvey(surveyid: String, pollAnswers: [[String: Any]])
    case eventData(page: Int, eventType: Int)
    
    case liveStreaming()
    case volunteerOptions()
    case userUpdatetoVolunteer(volunteer_id: String, description: String)
    case observations(desc: String, images: [String])
    case addVisitorForm(groupType: String, dateofVisit: String, numberAdults: String, numberChild: String, vistiorName: String, gender: String, nationality: String, dateofBirth: String, address: String, mobileNo: String, email: String, state: String, idType: String, idnumber: String, individualvisitor: String, accPersonName1: String, accPersonName2: String, accPersonName3: String, accPersonName4: String)
    case getIDCards()
    case aboutLTGovernor()
    case PublicationsTypes()
    case Publications(typeID: String, page: Int)
    case ViewProfile()
    case UpdateProfile(username: String, emailID: String, userPhone: String, userDOB: String, userGender: String, userAadhar: String, userVoter: String, useraddress1: String, useraddress2: String)
    
    case notifications()
    
    // Update Mobile
    case getOTP(mobile: String)
    case updateMobileNumber(mobile: String)
   
}

extension SabithaAPI: TargetType {
    var baseURL: URL {
//        switch self {
//        case .registerPetition, .Grievancetypes, .districts, .viewStatusofPetition:
//            return URL(string: "http://164.100.148.140/lgpmsapi/api/LGPMS")!
//        default:
            return URL(string: "http://ifuture.us/sabithaindrareddy/api")!
//        }
    }
    
    var path: String {
        switch self {
        case .deviceTokenRegister:
            return "/token_register"
        case .registeration:
            return "/registration"
        case .otpVerify:
            return "/verify_otp"

        case .feedData:
            return "/news_feeds"
        case .eventData:
            return "/events"
        case . surveyData:
            return "/surveys"
        case .submitSurvey:
            return "/submit_poll"
            
        case .liveStreaming:
            return "/liveStreams"
        case .volunteerOptions:
            return "/volunteer_skills"
        case .userUpdatetoVolunteer:
            return "/add_volunteer"
        
        case .observations:
            return "/add_observation"
        case .addVisitorForm:
            return "/add_visitor"
        case .surveyDetailData:
            return "/servey_questions"
        
        case .getIDCards:
            return "/id_types"
        case .aboutLTGovernor:
            return "/about_us"
            
        case .registerPetition:
            return "/grievanceRegister"
        case .Grievancetypes:
            return "/grievanceTypes"
        case .complaints:
            return "/complaintsList"
        case .viewStatusofPetition:
            return "/viewPetitionStatus"
        case .Publications:
            return "/publications"
        case .PublicationsTypes:
            return "/publication_types"
        case .ViewProfile:
            return "/user_profile"
        case .UpdateProfile:
            return "/updateProfile"
        case .ValidateUser:
            return "/validate_user"
        case .notifications:
            return "/notifications"
        case .getOTP:
            return "/getOTP"
        case .updateMobileNumber:
            return "/updatemobile"
        case .getTicketsList:
            return "/viewpetitionlist"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .Grievancetypes, .complaints, .viewStatusofPetition, .getTicketsList:
            return .get
        default:
             return .post
        }
    }
    
    var parameters: [String : Any]? {
        var params = [String: Any]()
        
        switch self {
        case .deviceTokenRegister(let deviceToken, let deviceID, let deviceType):
            params["device_token"] = deviceToken
            params["device_id"] = deviceID
            params["member_id"] = SabithaUserDefaults.loggedInUserID
            params["device_type"] = deviceType
        case .registeration(let mobileNo):
            params["user_mobile"] = mobileNo
        case .otpVerify(let mobileno, let otp):
            params["user_mobile"] = mobileno
            params["mobile_verified_otp"] = otp
        case .feedData(let page):
            params["pg"] = page
        case .surveyData(let page):
            params["pg"] = page
            params["poll_user_id"] = SabithaUserDefaults.loggedInUserID
        case .submitSurvey(let surveyid, let pollAnswers):
            params["poll_servey_id"] = surveyid
            params["poll_user_id"] = SabithaUserDefaults.loggedInUserID
            params["token"] = SabithaUserDefaults.loggedInToken
            params["poll_questions"] = pollAnswers
        case .eventData(let page, let type):
            params["pg"] = page
            params["events_type"] = type
        case .liveStreaming: break
        case .volunteerOptions: break
        case .userUpdatetoVolunteer(let volunteer_id, let description):
            params["user_id"] = SabithaUserDefaults.loggedInUserID
            params["token"] = SabithaUserDefaults.loggedInToken
            params["skill_ids"] = volunteer_id
            params["volunteer_desc"] = description
        case .observations(let obsdesc, let imageArray):
            params["user_id"] = SabithaUserDefaults.loggedInUserID
            params["token"] = SabithaUserDefaults.loggedInToken
            params["observation_desc"] = obsdesc
            params["observation_images"] = imageArray

        case .surveyDetailData(let surveyid):
            params["survey_id"] = surveyid
        case .addVisitorForm(let groupType, let dateofVisit, let numberAdults, let numberChild, let vistiorName, let gender, let nationality, let dateofBirth, let address, let mobileNo, let email, let state, let idType, let idnumber, let individualvisitor, let accPersonName1, let accPersonName2, let accPersonName3, let accPersonName4):
            params["visit_group_type"] = groupType
            params["visit_date"] = dateofVisit
            params["user_id"] = SabithaUserDefaults.loggedInUserID
            params["token"] = SabithaUserDefaults.loggedInToken
            params["visit_audults"] = numberAdults
            params["visit_children"] = numberChild
            params["visit_name"] = vistiorName
            params["visit_gender"] = gender
            params["visit_nationality"] = nationality
            params["visit_dob"] = dateofBirth
            params["visit_address"] = address
            params["visit_mobile"] = mobileNo
            params["visit_email"] = email
            params["visit_state"] = state
            params["visit_id_type"] = idType
            params["visit_id_number"] = idnumber
            params["visit_samll_group_desc"] = individualvisitor
            params["a_person1"] = accPersonName1
            params["a_person2"] = accPersonName2
            params["a_person3"] = accPersonName3
            params["a_person4"] = accPersonName4
        case .getIDCards: break
        case .aboutLTGovernor: break
            
        case .registerPetition(let gtype, let complaint, let grievanceDetails, let uploadedImageone, let uploadedImagetwo, let uploadedImagethree):
            params["user_id"] = SabithaUserDefaults.loggedInUserID
            params["token"] = SabithaUserDefaults.loggedInToken
            params["grievanceTypeId"] = gtype
            params["complaintListId"] = complaint
            params["grievanceDetails"] = grievanceDetails
            params["uploadedImage"] = uploadedImageone
            params["uploadedImage1"] = uploadedImagetwo
            params["uploadedImage2"] = uploadedImagethree
        case .Grievancetypes: break
        case .complaints(let typeID):
            params["grievance_id"] = typeID
        case .viewStatusofPetition(let petitioncode):
            params["grievance_number"] = petitioncode
        case .Publications(let typeID, let page):
            params["type_id"] = typeID
            params["pg"] = page
        case .PublicationsTypes: break
        case .ViewProfile:
            params["user_id"] = SabithaUserDefaults.loggedInUserID
        case .UpdateProfile(let username, let emailID, let userPhone, let userDOB, let userGender, let userAadhar, let userVoter, let useradd1, let useradd2):
            params["user_id"] = SabithaUserDefaults.loggedInUserID
            params["user_name"] = username
            params["user_email"] = emailID
            params["user_mobile"] = userPhone
            params["user_dob"] = userDOB
            params["user_gender"] = userGender
            params["user_aadhaar_card"] = userAadhar
            params["user_voter_id"] = userVoter
            params["user_address1"] = useradd1
            params["user_address2"] = useradd2
        case .ValidateUser:
             params["user_id"] = SabithaUserDefaults.loggedInUserID
        case .notifications:
            params["user_id"] = SabithaUserDefaults.loggedInUserID
        case .getOTP(let mobile):
            params["user_mobile"] = mobile
        case .updateMobileNumber(let mobile):
            params["user_id"] = SabithaUserDefaults.loggedInUserID
            params["new_mobile"] = mobile
        case .getTicketsList:
            params["user_id"] = SabithaUserDefaults.loggedInUserID
        }
        return params
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var parameterEncoding: ParameterEncoding {
        if method == .get {
            return URLEncoding.default
        } else {
            switch self {
//            case .registerPetition:
//                return JSONEncoding.default
            case .observations:
                return JSONEncoding.default
            case .submitSurvey:
                return JSONEncoding.default
            default:
                 return URLEncoding.default
            }
        }
    }
    
    var task: Task {
        guard let params = parameters else {
            return .requestPlain
        }
        
        return .requestParameters(parameters: params, encoding: parameterEncoding)
    }
    
    var headers: [String : String]? {
        return nil
    }
}
