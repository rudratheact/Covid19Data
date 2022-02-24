//
//  GetCompleteData.swift
//  Covid19Stats
//
//  Created by Rudra Evolut on 23/02/22.
//

import Foundation

/*
 No need of any optional types as all the elements are String type
 */

// MARK: - GetCompleteData
struct GetCompleteData: Codable {
    let casesTimeSeries: [CasesTimeSeries]
    let statewise: [Statewise]
    let tested: [Tested]

    enum CodingKeys: String, CodingKey {
        case casesTimeSeries = "cases_time_series"
        case statewise, tested
    }
}

// MARK: - CasesTimeSery
struct CasesTimeSeries: Codable {
    let dailyconfirmed, dailydeceased, dailyrecovered, date: String
    let dateymd, totalconfirmed, totaldeceased, totalrecovered: String
}

// MARK: - Statewise
struct Statewise: Codable {
    let active, confirmed, deaths, deltaconfirmed: String
    let deltadeaths, deltarecovered: String
    let lastupdatedtime: String
    let migratedother, recovered, state, statecode: String
    let statenotes: String
}

// MARK: - Tested
struct Tested: Codable {
    let dailyrtpcrsamplescollectedicmrapplication, firstdoseadministered, frontlineworkersvaccinated1Stdose, frontlineworkersvaccinated2Nddose: String
    let healthcareworkersvaccinated1Stdose, healthcareworkersvaccinated2Nddose, over45Years1Stdose, over45Years2Nddose: String
    let over60Years1Stdose, over60Years2Nddose, positivecasesfromsamplesreported, registration1845Years: String
    let registrationabove45Years, registrationflwhcw, registrationonline, registrationonspot: String
    let samplereportedtoday, seconddoseadministered: String
    let source: String
    let source2: String
    let source3, source4: String
    let testedasof, testsconductedbyprivatelabs, to60YearswithcoMorbidities1Stdose, to60YearswithcoMorbidities2Nddose: String
    let totaldosesadministered, totaldosesavailablewithstates, totaldosesavailablewithstatesprivatehospitals, totaldosesinpipeline: String
    let totaldosesprovidedtostatesuts, totalindividualsregistered, totalindividualstested, totalpositivecases: String
    let totalrtpcrsamplescollectedicmrapplication, totalsamplestested, totalsessionsconducted, totalvaccineconsumptionincludingwastage: String
    let updatetimestamp, years1Stdose, years2Nddose: String

    enum CodingKeys: String, CodingKey {
        case dailyrtpcrsamplescollectedicmrapplication, firstdoseadministered
        case frontlineworkersvaccinated1Stdose = "frontlineworkersvaccinated1stdose"
        case frontlineworkersvaccinated2Nddose = "frontlineworkersvaccinated2nddose"
        case healthcareworkersvaccinated1Stdose = "healthcareworkersvaccinated1stdose"
        case healthcareworkersvaccinated2Nddose = "healthcareworkersvaccinated2nddose"
        case over45Years1Stdose = "over45years1stdose"
        case over45Years2Nddose = "over45years2nddose"
        case over60Years1Stdose = "over60years1stdose"
        case over60Years2Nddose = "over60years2nddose"
        case positivecasesfromsamplesreported
        case registration1845Years = "registration18-45years"
        case registrationabove45Years = "registrationabove45years"
        case registrationflwhcw, registrationonline, registrationonspot, samplereportedtoday, seconddoseadministered, source, source2, source3, source4, testedasof, testsconductedbyprivatelabs
        case to60YearswithcoMorbidities1Stdose = "to60yearswithco-morbidities1stdose"
        case to60YearswithcoMorbidities2Nddose = "to60yearswithco-morbidities2nddose"
        case totaldosesadministered, totaldosesavailablewithstates, totaldosesavailablewithstatesprivatehospitals, totaldosesinpipeline, totaldosesprovidedtostatesuts, totalindividualsregistered, totalindividualstested, totalpositivecases, totalrtpcrsamplescollectedicmrapplication, totalsamplestested, totalsessionsconducted, totalvaccineconsumptionincludingwastage, updatetimestamp
        case years1Stdose = "years1stdose"
        case years2Nddose = "years2nddose"
    }
}

// MARK: - DecoratedText
enum DecoratedText: String{
    // Cases
    case date = "Date : "
    case totalconfirmed = "Total Confirmed : "
    case totaldeceased = "Total Deceased : "
    case totalrecovered = "Total Recovered : "
    // States
    case recovered = "Recovered : "
    case state = "State : "
    case active = "Active : "
    case deaths = "Deaths : "
    // Tests
    case testedasof = "Tested as of : "
    case dailyrtpcrsamplescollectedicmrapplication = "Daily RTPCR Samples Collected : "
    case samplereportedtoday = "Sample reported today : "
    case totaldosesadministered = "Total Doses Administered : "
}

enum SelectedArrayName: String{
    case cases, states, tests
}
