//
//  Rates.swift
//  OnTravel
//
//  Created by Gerrit Grunwald on 10.09.24.
//

import Foundation


class Rates: Codable {
      var NIO: Double?
      var BSD: Double?
      var KGS: Double?
      var KES: Double?
      var KYD: Double?
      var BYN: Double?
      var SAR: Double?
      var LYD: Double?
      var PEN: Double?
      var SDG: Double?
      var TWD: Double?
      var NPR: Double?
      var IMP: Double?
      var PAB: Double?
      var UZS: Double?
      var ILS: Double?
      var GGP: Double?
      var CHF: Double?
      var GMD: Double?
      var TJS: Double?
      var BIF: Double?
      var CLP: Double?
      var GHS: Double?
      var BOB: Double?
      var AWG: Double?
      var HTG: Double?
      var SOS: Double?
      var RUB: Double?
      var MNT: Double?
      var GIP: Double?
      var GTQ: Double?
      var NAD: Double?
      var VND: Double?
      var ETB: Double?
      var MOP: Double?
      var INR: Double?
      var MAD: Double?
      var VUV: Double?
      var SLL: Double?
      var AED: Double?
      var DZD: Double?
      var TZS: Double?
      var JPY: Double?
      var ARS: Double?
      var KRW: Double?
      var GEL: Double?
      var CRC: Double?
      var WST: Double?
      var CVE: Double?
      var MMK: Double?
      var GBP: Double?
      var IDR: Double?
      var MWK: Double?
      var UGX: Double?
      var RON: Double?
      var VES: Double?
      var TTD: Double?
      var GYD: Double?
      var PHP: Double?
      var ERN: Double?
      var MRU: Double?
      var AUD: Double?
      var FJD: Double?
      var LAK: Double?
      var SZL: Double?
      var BDT: Double?
      var SHP: Double?
      var ZMW: Double?
      var PGK: Double?
      var ISK: Double?
      var NOK: Double?
      var JMD: Double?
      var FOK: Double?
      var JEP: Double?
      var AMD: Double?
      var ZWL: Double?
      var SLE: Double?
      var KWD: Double?
      var XAF: Double?
      var BBD: Double?
      var UAH: Double?
      var BRL: Double?
      var HKD: Double?
      var BTN: Double?
      var BGN: Double?
      var UYU: Double?
      var RWF: Double?
      var USD: Double?
      var LRD: Double?
      var SBD: Double?
      var TMT: Double?
      var NZD: Double?
      var MGA: Double?
      var SGD: Double?
      var DJF: Double?
      var RSD: Double?
      var MDL: Double?
      var LBP: Double?
      var PYG: Double?
      var BWP: Double?
      var MZN: Double?
      var AOA: Double?
      var BMD: Double?
      var BAM: Double?
      var QAR: Double?
      var MVR: Double?
      var ANG: Double?
      var PLN: Double?
      var XDR: Double?
      var CZK: Double?
      var XOF: Double?
      var COP: Double?
      var SRD: Double?
      var XCD: Double?
      var TVD: Double?
      var BZD: Double?
      var SYP: Double?
      var KHR: Double?
      var BND: Double?
      var TRY: Double?
      var SEK: Double?
      var STN: Double?
      var MYR: Double?
      var KID: Double?
      var IRR: Double?
      var TOP: Double?
      var OMR: Double?
      var MXN: Double?
      var HRK: Double?
      var SCR: Double?
      var HNL: Double?
      var PKR: Double?
      var KZT: Double?
      var DOP: Double?
      var LSL: Double?
      var IQD: Double?
      var THB: Double?
      var CDF: Double?
      var GNF: Double?
      var MUR: Double?
      var AZN: Double?
      var KMF: Double?
      var BHD: Double?
      var NGN: Double?
      var CNY: Double?
      var TND: Double?
      var HUF: Double?
      var EUR: Double?
      var MKD: Double?
      var ALL: Double?
      var EGP: Double?
      var CAD: Double?
      var XPF: Double?
      var LKR: Double?
      var AFN: Double?
      var FKP: Double?
      var SSP: Double?
      var JOD: Double?
      var YER: Double?
      var CUP: Double?
      var DKK: Double?
      var ZAR: Double?

    private enum CodingKeys: String, CodingKey, CaseIterable {
        case NIO = "NIO"
        case BSD = "BSD"
        case KGS = "KGS"
        case KES = "KES"
        case KYD = "KYD"
        case BYN = "BYN"
        case SAR = "SAR"
        case LYD = "LYD"
        case PEN = "PEN"
        case SDG = "SDG"
        case TWD = "TWD"
        case NPR = "NPR"
        case IMP = "IMP"
        case PAB = "PAB"
        case UZS = "UZS"
        case ILS = "ILS"
        case GGP = "GGP"
        case CHF = "CHF"
        case GMD = "GMD"
        case TJS = "TJS"
        case BIF = "BIF"
        case CLP = "CLP"
        case GHS = "GHS"
        case BOB = "BOB"
        case AWG = "AWG"
        case HTG = "HTG"
        case SOS = "SOS"
        case RUB = "RUB"
        case MNT = "MNT"
        case GIP = "GIP"
        case GTQ = "GTQ"
        case NAD = "NAD"
        case VND = "VND"
        case ETB = "ETB"
        case MOP = "MOP"
        case INR = "INR"
        case MAD = "MAD"
        case VUV = "VUV"
        case SLL = "SLL"
        case AED = "AED"
        case DZD = "DZD"
        case TZS = "TZS"
        case JPY = "JPY"
        case ARS = "ARS"
        case KRW = "KRW"
        case GEL = "GEL"
        case CRC = "CRC"
        case WST = "WST"
        case CVE = "CVE"
        case MMK = "MMK"
        case GBP = "GBP"
        case IDR = "IDR"
        case MWK = "MWK"
        case UGX = "UGX"
        case RON = "RON"
        case VES = "VES"
        case TTD = "TTD"
        case GYD = "GYD"
        case PHP = "PHP"
        case ERN = "ERN"
        case MRU = "MRU"
        case AUD = "AUD"
        case FJD = "FJD"
        case LAK = "LAK"
        case SZL = "SZL"
        case BDT = "BDT"
        case SHP = "SHP"
        case ZMW = "ZMW"
        case PGK = "PGK"
        case ISK = "ISK"
        case NOK = "NOK"
        case JMD = "JMD"
        case FOK = "FOK"
        case JEP = "JEP"
        case AMD = "AMD"
        case ZWL = "ZWL"
        case SLE = "SLE"
        case KWD = "KWD"
        case XAF = "XAF"
        case BBD = "BBD"
        case UAH = "UAH"
        case BRL = "BRL"
        case HKD = "HKD"
        case BTN = "BTN"
        case BGN = "BGN"
        case UYU = "UYU"
        case RWF = "RWF"
        case USD = "USD"
        case LRD = "LRD"
        case SBD = "SBD"
        case TMT = "TMT"
        case NZD = "NZD"
        case MGA = "MGA"
        case SGD = "SGD"
        case DJF = "DJF"
        case RSD = "RSD"
        case MDL = "MDL"
        case LBP = "LBP"
        case PYG = "PYG"
        case BWP = "BWP"
        case MZN = "MZN"
        case AOA = "AOA"
        case BMD = "BMD"
        case BAM = "BAM"
        case QAR = "QAR"
        case MVR = "MVR"
        case ANG = "ANG"
        case PLN = "PLN"
        case XDR = "XDR"
        case CZK = "CZK"
        case XOF = "XOF"
        case COP = "COP"
        case SRD = "SRD"
        case XCD = "XCD"
        case TVD = "TVD"
        case BZD = "BZD"
        case SYP = "SYP"
        case KHR = "KHR"
        case BND = "BND"
        case TRY = "TRY"
        case SEK = "SEK"
        case STN = "STN"
        case MYR = "MYR"
        case KID = "KID"
        case IRR = "IRR"
        case TOP = "TOP"
        case OMR = "OMR"
        case MXN = "MXN"
        case HRK = "HRK"
        case SCR = "SCR"
        case HNL = "HNL"
        case PKR = "PKR"
        case KZT = "KZT"
        case DOP = "DOP"
        case LSL = "LSL"
        case IQD = "IQD"
        case THB = "THB"
        case CDF = "CDF"
        case GNF = "GNF"
        case MUR = "MUR"
        case AZN = "AZN"
        case KMF = "KMF"
        case BHD = "BHD"
        case NGN = "NGN"
        case CNY = "CNY"
        case TND = "TND"
        case HUF = "HUF"
        case EUR = "EUR"
        case MKD = "MKD"
        case ALL = "ALL"
        case EGP = "EGP"
        case CAD = "CAD"
        case XPF = "XPF"
        case LKR = "LKR"
        case AFN = "AFN"
        case FKP = "FKP"
        case SSP = "SSP"
        case JOD = "JOD"
        case YER = "YER"
        case CUP = "CUP"
        case DKK = "DKK"
        case ZAR = "ZAR"
    }

    
    required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    NIO = try? container.decode(Double.self, forKey: .NIO)
    BSD = try? container.decode(Double.self, forKey: .BSD)
    KGS = try? container.decode(Double.self, forKey: .KGS)
    KES = try? container.decode(Double.self, forKey: .KES)
    KYD = try? container.decode(Double.self, forKey: .KYD)
    BYN = try? container.decode(Double.self, forKey: .BYN)
    SAR = try? container.decode(Double.self, forKey: .SAR)
    LYD = try? container.decode(Double.self, forKey: .LYD)
    PEN = try? container.decode(Double.self, forKey: .PEN)
    SDG = try? container.decode(Double.self, forKey: .SDG)
    TWD = try? container.decode(Double.self, forKey: .TWD)
    NPR = try? container.decode(Double.self, forKey: .NPR)
    IMP = try? container.decode(Double.self, forKey: .IMP)
    PAB = try? container.decode(Double.self, forKey: .PAB)
    UZS = try? container.decode(Double.self, forKey: .UZS)
    ILS = try? container.decode(Double.self, forKey: .ILS)
    GGP = try? container.decode(Double.self, forKey: .GGP)
    CHF = try? container.decode(Double.self, forKey: .CHF)
    GMD = try? container.decode(Double.self, forKey: .GMD)
    TJS = try? container.decode(Double.self, forKey: .TJS)
    BIF = try? container.decode(Double.self, forKey: .BIF)
    CLP = try? container.decode(Double.self, forKey: .CLP)
    GHS = try? container.decode(Double.self, forKey: .GHS)
    BOB = try? container.decode(Double.self, forKey: .BOB)
    AWG = try? container.decode(Double.self, forKey: .AWG)
    HTG = try? container.decode(Double.self, forKey: .HTG)
    SOS = try? container.decode(Double.self, forKey: .SOS)
    RUB = try? container.decode(Double.self, forKey: .RUB)
    MNT = try? container.decode(Double.self, forKey: .MNT)
    GIP = try? container.decode(Double.self, forKey: .GIP)
    GTQ = try? container.decode(Double.self, forKey: .GTQ)
    NAD = try? container.decode(Double.self, forKey: .NAD)
    VND = try? container.decode(Double.self, forKey: .VND)
    ETB = try? container.decode(Double.self, forKey: .ETB)
    MOP = try? container.decode(Double.self, forKey: .MOP)
    INR = try? container.decode(Double.self, forKey: .INR)
    MAD = try? container.decode(Double.self, forKey: .MAD)
    VUV = try? container.decode(Double.self, forKey: .VUV)
    SLL = try? container.decode(Double.self, forKey: .SLL)
    AED = try? container.decode(Double.self, forKey: .AED)
    DZD = try? container.decode(Double.self, forKey: .DZD)
    TZS = try? container.decode(Double.self, forKey: .TZS)
    JPY = try? container.decode(Double.self, forKey: .JPY)
    ARS = try? container.decode(Double.self, forKey: .ARS)
    KRW = try? container.decode(Double.self, forKey: .KRW)
    GEL = try? container.decode(Double.self, forKey: .GEL)
    CRC = try? container.decode(Double.self, forKey: .CRC)
    WST = try? container.decode(Double.self, forKey: .WST)
    CVE = try? container.decode(Double.self, forKey: .CVE)
    MMK = try? container.decode(Double.self, forKey: .MMK)
    GBP = try? container.decode(Double.self, forKey: .GBP)
    IDR = try? container.decode(Double.self, forKey: .IDR)
    MWK = try? container.decode(Double.self, forKey: .MWK)
    UGX = try? container.decode(Double.self, forKey: .UGX)
    RON = try? container.decode(Double.self, forKey: .RON)
    VES = try? container.decode(Double.self, forKey: .VES)
    TTD = try? container.decode(Double.self, forKey: .TTD)
    GYD = try? container.decode(Double.self, forKey: .GYD)
    PHP = try? container.decode(Double.self, forKey: .PHP)
    ERN = try? container.decode(Double.self, forKey: .ERN)
    MRU = try? container.decode(Double.self, forKey: .MRU)
    AUD = try? container.decode(Double.self, forKey: .AUD)
    FJD = try? container.decode(Double.self, forKey: .FJD)
    LAK = try? container.decode(Double.self, forKey: .LAK)
    SZL = try? container.decode(Double.self, forKey: .SZL)
    BDT = try? container.decode(Double.self, forKey: .BDT)
    SHP = try? container.decode(Double.self, forKey: .SHP)
    ZMW = try? container.decode(Double.self, forKey: .ZMW)
    PGK = try? container.decode(Double.self, forKey: .PGK)
    ISK = try? container.decode(Double.self, forKey: .ISK)
    NOK = try? container.decode(Double.self, forKey: .NOK)
    JMD = try? container.decode(Double.self, forKey: .JMD)
    FOK = try? container.decode(Double.self, forKey: .FOK)
    JEP = try? container.decode(Double.self, forKey: .JEP)
    AMD = try? container.decode(Double.self, forKey: .AMD)
    ZWL = try? container.decode(Double.self, forKey: .ZWL)
    SLE = try? container.decode(Double.self, forKey: .SLE)
    KWD = try? container.decode(Double.self, forKey: .KWD)
    XAF = try? container.decode(Double.self, forKey: .XAF)
    BBD = try? container.decode(Double.self, forKey: .BBD)
    UAH = try? container.decode(Double.self, forKey: .UAH)
    BRL = try? container.decode(Double.self, forKey: .BRL)
    HKD = try? container.decode(Double.self, forKey: .HKD)
    BTN = try? container.decode(Double.self, forKey: .BTN)
    BGN = try? container.decode(Double.self, forKey: .BGN)
    UYU = try? container.decode(Double.self, forKey: .UYU)
    RWF = try? container.decode(Double.self, forKey: .RWF)
    USD = try? container.decode(Double.self, forKey: .USD)
    LRD = try? container.decode(Double.self, forKey: .LRD)
    SBD = try? container.decode(Double.self, forKey: .SBD)
    TMT = try? container.decode(Double.self, forKey: .TMT)
    NZD = try? container.decode(Double.self, forKey: .NZD)
    MGA = try? container.decode(Double.self, forKey: .MGA)
    SGD = try? container.decode(Double.self, forKey: .SGD)
    DJF = try? container.decode(Double.self, forKey: .DJF)
    RSD = try? container.decode(Double.self, forKey: .RSD)
    MDL = try? container.decode(Double.self, forKey: .MDL)
    LBP = try? container.decode(Double.self, forKey: .LBP)
    PYG = try? container.decode(Double.self, forKey: .PYG)
    BWP = try? container.decode(Double.self, forKey: .BWP)
    MZN = try? container.decode(Double.self, forKey: .MZN)
    AOA = try? container.decode(Double.self, forKey: .AOA)
    BMD = try? container.decode(Double.self, forKey: .BMD)
    BAM = try? container.decode(Double.self, forKey: .BAM)
    QAR = try? container.decode(Double.self, forKey: .QAR)
    MVR = try? container.decode(Double.self, forKey: .MVR)
    ANG = try? container.decode(Double.self, forKey: .ANG)
    PLN = try? container.decode(Double.self, forKey: .PLN)
    XDR = try? container.decode(Double.self, forKey: .XDR)
    CZK = try? container.decode(Double.self, forKey: .CZK)
    XOF = try? container.decode(Double.self, forKey: .XOF)
    COP = try? container.decode(Double.self, forKey: .COP)
    SRD = try? container.decode(Double.self, forKey: .SRD)
    XCD = try? container.decode(Double.self, forKey: .XCD)
    TVD = try? container.decode(Double.self, forKey: .TVD)
    BZD = try? container.decode(Double.self, forKey: .BZD)
    SYP = try? container.decode(Double.self, forKey: .SYP)
    KHR = try? container.decode(Double.self, forKey: .KHR)
    BND = try? container.decode(Double.self, forKey: .BND)
    TRY = try? container.decode(Double.self, forKey: .TRY)
    SEK = try? container.decode(Double.self, forKey: .SEK)
    STN = try? container.decode(Double.self, forKey: .STN)
    MYR = try? container.decode(Double.self, forKey: .MYR)
    KID = try? container.decode(Double.self, forKey: .KID)
    IRR = try? container.decode(Double.self, forKey: .IRR)
    TOP = try? container.decode(Double.self, forKey: .TOP)
    OMR = try? container.decode(Double.self, forKey: .OMR)
    MXN = try? container.decode(Double.self, forKey: .MXN)
    HRK = try? container.decode(Double.self, forKey: .HRK)
    SCR = try? container.decode(Double.self, forKey: .SCR)
    HNL = try? container.decode(Double.self, forKey: .HNL)
    PKR = try? container.decode(Double.self, forKey: .PKR)
    KZT = try? container.decode(Double.self, forKey: .KZT)
    DOP = try? container.decode(Double.self, forKey: .DOP)
    LSL = try? container.decode(Double.self, forKey: .LSL)
    IQD = try? container.decode(Double.self, forKey: .IQD)
    THB = try? container.decode(Double.self, forKey: .THB)
    CDF = try? container.decode(Double.self, forKey: .CDF)
    GNF = try? container.decode(Double.self, forKey: .GNF)
    MUR = try? container.decode(Double.self, forKey: .MUR)
    AZN = try? container.decode(Double.self, forKey: .AZN)
    KMF = try? container.decode(Double.self, forKey: .KMF)
    BHD = try? container.decode(Double.self, forKey: .BHD)
    NGN = try? container.decode(Double.self, forKey: .NGN)
    CNY = try? container.decode(Double.self, forKey: .CNY)
    TND = try? container.decode(Double.self, forKey: .TND)
    HUF = try? container.decode(Double.self, forKey: .HUF)
    EUR = try? container.decode(Double.self, forKey: .EUR)
    MKD = try? container.decode(Double.self, forKey: .MKD)
    ALL = try? container.decode(Double.self, forKey: .ALL)
    EGP = try? container.decode(Double.self, forKey: .EGP)
    CAD = try? container.decode(Double.self, forKey: .CAD)
    XPF = try? container.decode(Double.self, forKey: .XPF)
    LKR = try? container.decode(Double.self, forKey: .LKR)
    AFN = try? container.decode(Double.self, forKey: .AFN)
    FKP = try? container.decode(Double.self, forKey: .FKP)
    SSP = try? container.decode(Double.self, forKey: .SSP)
    JOD = try? container.decode(Double.self, forKey: .JOD)
    YER = try? container.decode(Double.self, forKey: .YER)
    CUP = try? container.decode(Double.self, forKey: .CUP)
    DKK = try? container.decode(Double.self, forKey: .DKK)
    ZAR = try? container.decode(Double.self, forKey: .ZAR)
  }

    
    public func getAll() -> [String:Double] {
        return [
            "NIO" : self.NIO ?? 0.0,
            "BSD" : self.BSD ?? 0.0,
            "KGS" : self.KGS ?? 0.0,
            "KES" : self.KES ?? 0.0,
            "KYD" : self.KYD ?? 0.0,
            "BYN" : self.BYN ?? 0.0,
            "SAR" : self.SAR ?? 0.0,
            "LYD" : self.LYD ?? 0.0,
            "PEN" : self.PEN ?? 0.0,
            "SDG" : self.SDG ?? 0.0,
            "TWD" : self.TWD ?? 0.0,
            "NPR" : self.NPR ?? 0.0,
            "IMP" : self.IMP ?? 0.0,
            "PAB" : self.PAB ?? 0.0,
            "UZS" : self.UZS ?? 0.0,
            "ILS" : self.ILS ?? 0.0,
            "GGP" : self.GGP ?? 0.0,
            "CHF" : self.CHF ?? 0.0,
            "GMD" : self.GMD ?? 0.0,
            "TJS" : self.TJS ?? 0.0,
            "BIF" : self.BIF ?? 0.0,
            "CLP" : self.CLP ?? 0.0,
            "GHS" : self.GHS ?? 0.0,
            "BOB" : self.BOB ?? 0.0,
            "AWG" : self.AWG ?? 0.0,
            "HTG" : self.HTG ?? 0.0,
            "SOS" : self.SOS ?? 0.0,
            "RUB" : self.RUB ?? 0.0,
            "MNT" : self.MNT ?? 0.0,
            "GIP" : self.GIP ?? 0.0,
            "GTQ" : self.GTQ ?? 0.0,
            "NAD" : self.NAD ?? 0.0,
            "VND" : self.VND ?? 0.0,
            "ETB" : self.ETB ?? 0.0,
            "MOP" : self.MOP ?? 0.0,
            "INR" : self.INR ?? 0.0,
            "MAD" : self.MAD ?? 0.0,
            "VUV" : self.VUV ?? 0.0,
            "SLL" : self.SLL ?? 0.0,
            "AED" : self.AED ?? 0.0,
            "DZD" : self.DZD ?? 0.0,
            "TZS" : self.TZS ?? 0.0,
            "JPY" : self.JPY ?? 0.0,
            "ARS" : self.ARS ?? 0.0,
            "KRW" : self.KRW ?? 0.0,
            "GEL" : self.GEL ?? 0.0,
            "CRC" : self.CRC ?? 0.0,
            "WST" : self.WST ?? 0.0,
            "CVE" : self.CVE ?? 0.0,
            "MMK" : self.MMK ?? 0.0,
            "GBP" : self.GBP ?? 0.0,
            "IDR" : self.IDR ?? 0.0,
            "MWK" : self.MWK ?? 0.0,
            "UGX" : self.UGX ?? 0.0,
            "RON" : self.RON ?? 0.0,
            "VES" : self.VES ?? 0.0,
            "TTD" : self.TTD ?? 0.0,
            "GYD" : self.GYD ?? 0.0,
            "PHP" : self.PHP ?? 0.0,
            "ERN" : self.ERN ?? 0.0,
            "MRU" : self.MRU ?? 0.0,
            "AUD" : self.AUD ?? 0.0,
            "FJD" : self.FJD ?? 0.0,
            "LAK" : self.LAK ?? 0.0,
            "SZL" : self.SZL ?? 0.0,
            "BDT" : self.BDT ?? 0.0,
            "SHP" : self.SHP ?? 0.0,
            "ZMW" : self.ZMW ?? 0.0,
            "PGK" : self.PGK ?? 0.0,
            "ISK" : self.ISK ?? 0.0,
            "NOK" : self.NOK ?? 0.0,
            "JMD" : self.JMD ?? 0.0,
            "FOK" : self.FOK ?? 0.0,
            "JEP" : self.JEP ?? 0.0,
            "AMD" : self.AMD ?? 0.0,
            "ZWL" : self.ZWL ?? 0.0,
            "SLE" : self.SLE ?? 0.0,
            "KWD" : self.KWD ?? 0.0,
            "XAF" : self.XAF ?? 0.0,
            "BBD" : self.BBD ?? 0.0,
            "UAH" : self.UAH ?? 0.0,
            "BRL" : self.BRL ?? 0.0,
            "HKD" : self.HKD ?? 0.0,
            "BTN" : self.BTN ?? 0.0,
            "BGN" : self.BGN ?? 0.0,
            "UYU" : self.UYU ?? 0.0,
            "RWF" : self.RWF ?? 0.0,
            "USD" : self.USD ?? 0.0,
            "LRD" : self.LRD ?? 0.0,
            "SBD" : self.SBD ?? 0.0,
            "TMT" : self.TMT ?? 0.0,
            "NZD" : self.NZD ?? 0.0,
            "MGA" : self.MGA ?? 0.0,
            "SGD" : self.SGD ?? 0.0,
            "DJF" : self.DJF ?? 0.0,
            "RSD" : self.RSD ?? 0.0,
            "MDL" : self.MDL ?? 0.0,
            "LBP" : self.LBP ?? 0.0,
            "PYG" : self.PYG ?? 0.0,
            "BWP" : self.BWP ?? 0.0,
            "MZN" : self.MZN ?? 0.0,
            "AOA" : self.AOA ?? 0.0,
            "BMD" : self.BMD ?? 0.0,
            "BAM" : self.BAM ?? 0.0,
            "QAR" : self.QAR ?? 0.0,
            "MVR" : self.MVR ?? 0.0,
            "ANG" : self.ANG ?? 0.0,
            "PLN" : self.PLN ?? 0.0,
            "XDR" : self.XDR ?? 0.0,
            "CZK" : self.CZK ?? 0.0,
            "XOF" : self.XOF ?? 0.0,
            "COP" : self.COP ?? 0.0,
            "SRD" : self.SRD ?? 0.0,
            "XCD" : self.XCD ?? 0.0,
            "TVD" : self.TVD ?? 0.0,
            "BZD" : self.BZD ?? 0.0,
            "SYP" : self.SYP ?? 0.0,
            "KHR" : self.KHR ?? 0.0,
            "BND" : self.BND ?? 0.0,
            "TRY" : self.TRY ?? 0.0,
            "SEK" : self.SEK ?? 0.0,
            "STN" : self.STN ?? 0.0,
            "MYR" : self.MYR ?? 0.0,
            "KID" : self.KID ?? 0.0,
            "IRR" : self.IRR ?? 0.0,
            "TOP" : self.TOP ?? 0.0,
            "OMR" : self.OMR ?? 0.0,
            "MXN" : self.MXN ?? 0.0,
            "HRK" : self.HRK ?? 0.0,
            "SCR" : self.SCR ?? 0.0,
            "HNL" : self.HNL ?? 0.0,
            "PKR" : self.PKR ?? 0.0,
            "KZT" : self.KZT ?? 0.0,
            "DOP" : self.DOP ?? 0.0,
            "LSL" : self.LSL ?? 0.0,
            "IQD" : self.IQD ?? 0.0,
            "THB" : self.THB ?? 0.0,
            "CDF" : self.CDF ?? 0.0,
            "GNF" : self.GNF ?? 0.0,
            "MUR" : self.MUR ?? 0.0,
            "AZN" : self.AZN ?? 0.0,
            "KMF" : self.KMF ?? 0.0,
            "BHD" : self.BHD ?? 0.0,
            "NGN" : self.NGN ?? 0.0,
            "CNY" : self.CNY ?? 0.0,
            "TND" : self.TND ?? 0.0,
            "HUF" : self.HUF ?? 0.0,
            "EUR" : self.EUR ?? 0.0,
            "MKD" : self.MKD ?? 0.0,
            "ALL" : self.ALL ?? 0.0,
            "EGP" : self.EGP ?? 0.0,
            "CAD" : self.CAD ?? 0.0,
            "XPF" : self.XPF ?? 0.0,
            "LKR" : self.LKR ?? 0.0,
            "AFN" : self.AFN ?? 0.0,
            "FKP" : self.FKP ?? 0.0,
            "SSP" : self.SSP ?? 0.0,
            "JOD" : self.JOD ?? 0.0,
            "YER" : self.YER ?? 0.0,
            "CUP" : self.CUP ?? 0.0,
            "DKK" : self.DKK ?? 0.0,
            "ZAR" : self.ZAR ?? 0.0,
        ]
    }
    
    func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try? container.encode(NIO, forKey: .NIO)
    try? container.encode(BSD, forKey: .BSD)
    try? container.encode(KGS, forKey: .KGS)
    try? container.encode(KES, forKey: .KES)
    try? container.encode(KYD, forKey: .KYD)
    try? container.encode(BYN, forKey: .BYN)
    try? container.encode(SAR, forKey: .SAR)
    try? container.encode(LYD, forKey: .LYD)
    try? container.encode(PEN, forKey: .PEN)
    try? container.encode(SDG, forKey: .SDG)
    try? container.encode(TWD, forKey: .TWD)
    try? container.encode(NPR, forKey: .NPR)
    try? container.encode(IMP, forKey: .IMP)
    try? container.encode(PAB, forKey: .PAB)
    try? container.encode(UZS, forKey: .UZS)
    try? container.encode(ILS, forKey: .ILS)
    try? container.encode(GGP, forKey: .GGP)
    try? container.encode(CHF, forKey: .CHF)
    try? container.encode(GMD, forKey: .GMD)
    try? container.encode(TJS, forKey: .TJS)
    try? container.encode(BIF, forKey: .BIF)
    try? container.encode(CLP, forKey: .CLP)
    try? container.encode(GHS, forKey: .GHS)
    try? container.encode(BOB, forKey: .BOB)
    try? container.encode(AWG, forKey: .AWG)
    try? container.encode(HTG, forKey: .HTG)
    try? container.encode(SOS, forKey: .SOS)
    try? container.encode(RUB, forKey: .RUB)
    try? container.encode(MNT, forKey: .MNT)
    try? container.encode(GIP, forKey: .GIP)
    try? container.encode(GTQ, forKey: .GTQ)
    try? container.encode(NAD, forKey: .NAD)
    try? container.encode(VND, forKey: .VND)
    try? container.encode(ETB, forKey: .ETB)
    try? container.encode(MOP, forKey: .MOP)
    try? container.encode(INR, forKey: .INR)
    try? container.encode(MAD, forKey: .MAD)
    try? container.encode(VUV, forKey: .VUV)
    try? container.encode(SLL, forKey: .SLL)
    try? container.encode(AED, forKey: .AED)
    try? container.encode(DZD, forKey: .DZD)
    try? container.encode(TZS, forKey: .TZS)
    try? container.encode(JPY, forKey: .JPY)
    try? container.encode(ARS, forKey: .ARS)
    try? container.encode(KRW, forKey: .KRW)
    try? container.encode(GEL, forKey: .GEL)
    try? container.encode(CRC, forKey: .CRC)
    try? container.encode(WST, forKey: .WST)
    try? container.encode(CVE, forKey: .CVE)
    try? container.encode(MMK, forKey: .MMK)
    try? container.encode(GBP, forKey: .GBP)
    try? container.encode(IDR, forKey: .IDR)
    try? container.encode(MWK, forKey: .MWK)
    try? container.encode(UGX, forKey: .UGX)
    try? container.encode(RON, forKey: .RON)
    try? container.encode(VES, forKey: .VES)
    try? container.encode(TTD, forKey: .TTD)
    try? container.encode(GYD, forKey: .GYD)
    try? container.encode(PHP, forKey: .PHP)
    try? container.encode(ERN, forKey: .ERN)
    try? container.encode(MRU, forKey: .MRU)
    try? container.encode(AUD, forKey: .AUD)
    try? container.encode(FJD, forKey: .FJD)
    try? container.encode(LAK, forKey: .LAK)
    try? container.encode(SZL, forKey: .SZL)
    try? container.encode(BDT, forKey: .BDT)
    try? container.encode(SHP, forKey: .SHP)
    try? container.encode(ZMW, forKey: .ZMW)
    try? container.encode(PGK, forKey: .PGK)
    try? container.encode(ISK, forKey: .ISK)
    try? container.encode(NOK, forKey: .NOK)
    try? container.encode(JMD, forKey: .JMD)
    try? container.encode(FOK, forKey: .FOK)
    try? container.encode(JEP, forKey: .JEP)
    try? container.encode(AMD, forKey: .AMD)
    try? container.encode(ZWL, forKey: .ZWL)
    try? container.encode(SLE, forKey: .SLE)
    try? container.encode(KWD, forKey: .KWD)
    try? container.encode(XAF, forKey: .XAF)
    try? container.encode(BBD, forKey: .BBD)
    try? container.encode(UAH, forKey: .UAH)
    try? container.encode(BRL, forKey: .BRL)
    try? container.encode(HKD, forKey: .HKD)
    try? container.encode(BTN, forKey: .BTN)
    try? container.encode(BGN, forKey: .BGN)
    try? container.encode(UYU, forKey: .UYU)
    try? container.encode(RWF, forKey: .RWF)
    try? container.encode(USD, forKey: .USD)
    try? container.encode(LRD, forKey: .LRD)
    try? container.encode(SBD, forKey: .SBD)
    try? container.encode(TMT, forKey: .TMT)
    try? container.encode(NZD, forKey: .NZD)
    try? container.encode(MGA, forKey: .MGA)
    try? container.encode(SGD, forKey: .SGD)
    try? container.encode(DJF, forKey: .DJF)
    try? container.encode(RSD, forKey: .RSD)
    try? container.encode(MDL, forKey: .MDL)
    try? container.encode(LBP, forKey: .LBP)
    try? container.encode(PYG, forKey: .PYG)
    try? container.encode(BWP, forKey: .BWP)
    try? container.encode(MZN, forKey: .MZN)
    try? container.encode(AOA, forKey: .AOA)
    try? container.encode(BMD, forKey: .BMD)
    try? container.encode(BAM, forKey: .BAM)
    try? container.encode(QAR, forKey: .QAR)
    try? container.encode(MVR, forKey: .MVR)
    try? container.encode(ANG, forKey: .ANG)
    try? container.encode(PLN, forKey: .PLN)
    try? container.encode(XDR, forKey: .XDR)
    try? container.encode(CZK, forKey: .CZK)
    try? container.encode(XOF, forKey: .XOF)
    try? container.encode(COP, forKey: .COP)
    try? container.encode(SRD, forKey: .SRD)
    try? container.encode(XCD, forKey: .XCD)
    try? container.encode(TVD, forKey: .TVD)
    try? container.encode(BZD, forKey: .BZD)
    try? container.encode(SYP, forKey: .SYP)
    try? container.encode(KHR, forKey: .KHR)
    try? container.encode(BND, forKey: .BND)
    try? container.encode(TRY, forKey: .TRY)
    try? container.encode(SEK, forKey: .SEK)
    try? container.encode(STN, forKey: .STN)
    try? container.encode(MYR, forKey: .MYR)
    try? container.encode(KID, forKey: .KID)
    try? container.encode(IRR, forKey: .IRR)
    try? container.encode(TOP, forKey: .TOP)
    try? container.encode(OMR, forKey: .OMR)
    try? container.encode(MXN, forKey: .MXN)
    try? container.encode(HRK, forKey: .HRK)
    try? container.encode(SCR, forKey: .SCR)
    try? container.encode(HNL, forKey: .HNL)
    try? container.encode(PKR, forKey: .PKR)
    try? container.encode(KZT, forKey: .KZT)
    try? container.encode(DOP, forKey: .DOP)
    try? container.encode(LSL, forKey: .LSL)
    try? container.encode(IQD, forKey: .IQD)
    try? container.encode(THB, forKey: .THB)
    try? container.encode(CDF, forKey: .CDF)
    try? container.encode(GNF, forKey: .GNF)
    try? container.encode(MUR, forKey: .MUR)
    try? container.encode(AZN, forKey: .AZN)
    try? container.encode(KMF, forKey: .KMF)
    try? container.encode(BHD, forKey: .BHD)
    try? container.encode(NGN, forKey: .NGN)
    try? container.encode(CNY, forKey: .CNY)
    try? container.encode(TND, forKey: .TND)
    try? container.encode(HUF, forKey: .HUF)
    try? container.encode(EUR, forKey: .EUR)
    try? container.encode(MKD, forKey: .MKD)
    try? container.encode(ALL, forKey: .ALL)
    try? container.encode(EGP, forKey: .EGP)
    try? container.encode(CAD, forKey: .CAD)
    try? container.encode(XPF, forKey: .XPF)
    try? container.encode(LKR, forKey: .LKR)
    try? container.encode(AFN, forKey: .AFN)
    try? container.encode(FKP, forKey: .FKP)
    try? container.encode(SSP, forKey: .SSP)
    try? container.encode(JOD, forKey: .JOD)
    try? container.encode(YER, forKey: .YER)
    try? container.encode(CUP, forKey: .CUP)
    try? container.encode(DKK, forKey: .DKK)
    try? container.encode(ZAR, forKey: .ZAR)
  }
}
