class ImportNetworks < ActiveRecord::Migration[6.0]
  LIST = [
    {
      "stationId": "16689",
      "callSign": "WCBSDT",
      "videoQuality": {
        "signalType": "Digital",
        "truResolution": "HD 1080i",
        "videoType": "HDTV"
      },
      "affiliateCallSign": "CBS",
      "affiliateId": "10098",
      "channel": "002",
      "preferredImage": {
        "width": "360",
        "height": "270",
        "uri": "http://wewe.tmsimg.com/assets/s10098_ll_h3_ab.png",
        "category": "Logo",
        "primary": "true"
      }
    },
    {
      "stationId": "20459",
      "callSign": "WNBCDT",
      "videoQuality": {
        "signalType": "Digital",
        "truResolution": "HD 1080i",
        "videoType": "HDTV"
      },
      "affiliateCallSign": "NBC",
      "affiliateId": "10991",
      "channel": "004",
      "preferredImage": {
        "width": "360",
        "height": "270",
        "uri": "http://wewe.tmsimg.com/assets/s28717_h3_aa.png",
        "category": "Logo",
        "primary": "true"
      }
    },
    {
      "stationId": "20453",
      "callSign": "WABCDT",
      "videoQuality": {
        "signalType": "Digital",
        "truResolution": "HD 720p",
        "videoType": "HDTV"
      },
      "affiliateCallSign": "ABC",
      "affiliateId": "10003",
      "channel": "007",
      "preferredImage": {
        "width": "360",
        "height": "270",
        "uri": "http://wewe.tmsimg.com/assets/s28708_h3_aa.png",
        "category": "Logo",
        "primary": "true"
      }
    },
    {
      "stationId": "20373",
      "callSign": "WPIXDT",
      "videoQuality": {
        "signalType": "Digital",
        "truResolution": "HD 1080p",
        "videoType": "HDTV"
      },
      "affiliateCallSign": "CW",
      "affiliateId": "51306",
      "channel": "011",
      "preferredImage": {
        "width": "360",
        "height": "270",
        "uri": "http://wewe.tmsimg.com/assets/s20373_ll_h3_aa.png",
        "category": "Logo",
        "primary": "true"
      }
    },
    {
      "stationId": "20360",
      "callSign": "WNYWDT",
      "videoQuality": {
        "signalType": "Digital",
        "truResolution": "HD 720p",
        "videoType": "HDTV"
      },
      "affiliateCallSign": "FOX",
      "affiliateId": "10212",
      "channel": "005",
      "preferredImage": {
        "width": "360",
        "height": "270",
        "uri": "http://wewe.tmsimg.com/assets/s28719_ll_h3_ac.png",
        "category": "Logo",
        "primary": "true"
      }
    },
    {
      "stationId": "19548",
      "callSign": "HBOHD",
      "videoQuality": {
        "signalType": "Digital",
        "truResolution": "HD 1080i",
        "videoType": "HDTV"
      },
      "channel": "301",
      "preferredImage": {
        "width": "360",
        "height": "270",
        "uri": "http://wewe.tmsimg.com/assets/s19548_ll_h3_aa.png",
        "category": "Logo",
        "primary": "true"
      }
    },
    {
      "stationId": "32026",
      "callSign": "SHOWDM",
      "videoQuality": {
        "signalType": "Digital",
        "videoType": "SDTV"
      },
      "channel": "320",
      "preferredImage": {
        "width": "360",
        "height": "270",
        "uri": "http://wewe.tmsimg.com/assets/s11115_ll_h3_ac.png",
        "category": "Logo",
        "primary": "true"
      }
    },
    {
      "stationId": "61469",
      "callSign": "CINHD",
      "videoQuality": {
        "signalType": "Digital",
        "truResolution": "HD 1080i",
        "videoType": "HDTV"
      },
      "channel": "152",
      "preferredImage": {
        "width": "360",
        "height": "270",
        "uri": "http://wewe.tmsimg.com/assets/s61469_ll_h3_ab.png",
        "category": "Logo",
        "primary": "true"
      }
    },
    {
      "stationId": "34941",
      "callSign": "STZHD",
      "videoQuality": {
        "signalType": "Digital",
        "truResolution": "HD 1080i",
        "videoType": "HDTV"
      },
      "channel": "341",
      "preferredImage": {
        "width": "360",
        "height": "270",
        "uri": "http://wewe.tmsimg.com/assets/s34941_ll_h3_ab.png",
        "category": "Logo",
        "primary": "true"
      }
    },
    {
      "stationId": "42642",
      "callSign": "TNTHD",
      "videoQuality": {
        "signalType": "Digital",
        "truResolution": "HD 1080i",
        "videoType": "HDTV"
      },
      "channel": "037",
      "preferredImage": {
        "width": "360",
        "height": "270",
        "uri": "http://wewe.tmsimg.com/assets/s42642_ll_h3_ab.png",
        "category": "Logo",
        "primary": "true"
      }
    },
    {
      "stationId": "63236",
      "callSign": "BETHD",
      "videoQuality": {
        "signalType": "Digital",
        "truResolution": "HD 1080i",
        "videoType": "HDTV"
      },
      "channel": "054",
      "preferredImage": {
        "width": "360",
        "height": "270",
        "uri": "http://wewe.tmsimg.com/assets/s63236_ll_h3_ab.png",
        "category": "Logo",
        "primary": "true"
      }
    },
    {
      "stationId": "58515",
      "callSign": "TBSHD",
      "videoQuality": {
        "signalType": "Digital",
        "truResolution": "HD 1080i",
        "videoType": "HDTV"
      },
      "channel": "039",
      "preferredImage": {
        "width": "360",
        "height": "270",
        "uri": "http://wewe.tmsimg.com/assets/s58515_ll_h3_ab.png",
        "category": "Logo",
        "primary": "true"
      }
    },
    {
      "stationId": "58452",
      "callSign": "USAHD",
      "videoQuality": {
        "signalType": "Digital",
        "truResolution": "HD 1080i",
        "videoType": "HDTV"
      },
      "channel": "038",
      "preferredImage": {
        "width": "360",
        "height": "270",
        "uri": "http://wewe.tmsimg.com/assets/s58452_ll_h3_ae.png",
        "category": "Logo",
        "primary": "true"
      }
    },
    {
      "stationId": "32645",
      "callSign": "ESPNHD",
      "videoQuality": {
        "signalType": "Digital",
        "truResolution": "HD 720p",
        "videoType": "HDTV"
      },
      "channel": "036",
      "preferredImage": {
        "width": "360",
        "height": "270",
        "uri": "http://wewe.tmsimg.com/assets/s32645_ll_h3_ab.png",
        "category": "Logo",
        "primary": "true"
      }
    },
    {
      "stationId": "60048",
      "callSign": "TOONHD",
      "videoQuality": {
        "signalType": "Digital",
        "truResolution": "HD 1080i",
        "videoType": "HDTV"
      },
      "channel": "032",
      "preferredImage": {
        "width": "360",
        "height": "270",
        "uri": "http://wewe.tmsimg.com/assets/s60048_ll_h3_ac.png",
        "category": "Logo",
        "primary": "true"
      }
    },
    {
      "stationId": "11006",
      "callSign": "NIK",
      "videoQuality": {
        "signalType": "Digital",
        "videoType": "SDTV"
      },
      "channel": "121",
      "preferredImage": {
        "width": "360",
        "height": "270",
        "uri": "http://wewe.tmsimg.com/assets/s11006_ll_h3_aa.png",
        "category": "Logo",
        "primary": "true"
      }
    },
    {
      "stationId": "60179",
      "callSign": "FNCHD",
      "videoQuality": {
        "signalType": "Digital",
        "truResolution": "HD 1080p",
        "videoType": "HDTV"
      },
      "channel": "026",
      "preferredImage": {
        "width": "360",
        "height": "270",
        "uri": "http://wewe.tmsimg.com/assets/s60179_ll_h3_ab.png",
        "category": "Logo",
        "primary": "true"
      }
    },
    {
      "stationId": "58646",
      "callSign": "CNNHD",
      "videoQuality": {
        "signalType": "Digital",
        "truResolution": "HD 1080i",
        "videoType": "HDTV"
      },
      "channel": "025",
      "preferredImage": {
        "width": "360",
        "height": "270",
        "uri": "http://wewe.tmsimg.com/assets/s58646_ll_h3_ac.png",
        "category": "Logo",
        "primary": "true"
      }
    },
    {
      "stationId": "58625",
      "callSign": "BRAVOHD",
      "videoQuality": {
        "signalType": "Digital",
        "truResolution": "HD 1080i",
        "videoType": "HDTV"
      },
      "channel": "044",
      "preferredImage": {
        "width": "360",
        "height": "270",
        "uri": "http://wewe.tmsimg.com/assets/s58625_h3_aa.png",
        "category": "Logo",
        "primary": "true"
      }
    },
    {
      "stationId": "45507",
      "callSign": "ESPN2HD",
      "videoQuality": {
        "signalType": "Digital",
        "truResolution": "HD 720p",
        "videoType": "HDTV"
      },
      "channel": "035",
      "preferredImage": {
        "width": "360",
        "height": "270",
        "uri": "http://wewe.tmsimg.com/assets/s45507_ll_h3_aa.png",
        "category": "Logo",
        "primary": "true"
      }
    },
    {
      "stationId": "43362",
      "callSign": "HISTE",
      "videoQuality": {
        "signalType": "Digital",
        "videoType": "SDTV"
      },
      "channel": "1017",
      "preferredImage": {
        "width": "360",
        "height": "270",
        "uri": "http://wewe.tmsimg.com/assets/s43362_ll_h3_ac.png",
        "category": "Logo",
        "primary": "true"
      }
    },
    {
      "stationId": "58623",
      "callSign": "SYFYHD",
      "videoQuality": {
        "signalType": "Digital",
        "truResolution": "HD 1080i",
        "videoType": "HDTV"
      },
      "channel": "048",
      "preferredImage": {
        "width": "360",
        "height": "270",
        "uri": "http://wewe.tmsimg.com/assets/s58623_ll_h3_ae.png",
        "category": "Logo",
        "primary": "true"
      }
    },
    {
      "stationId": "51529",
      "callSign": "AETVHD",
      "videoQuality": {
        "signalType": "Digital",
        "truResolution": "HD 1080i",
        "videoType": "HDTV"
      },
      "channel": "046",
      "preferredImage": {
        "width": "360",
        "height": "270",
        "uri": "http://wewe.tmsimg.com/assets/s51529_h3_aa.png",
        "category": "Logo",
        "primary": "true"
      }
    },
    {
      "stationId": "74550",
      "callSign": "UNITLNO",
      "videoQuality": {
        "signalType": "Digital",
        "videoType": "SDTV"
      },
      "channel": "1091",
      "preferredImage": {
        "width": "360",
        "height": "270",
        "uri": "http://wewe.tmsimg.com/assets/s74550_ll_h3_ab.png",
        "category": "Logo",
        "primary": "true"
      }
    },
    {
      "stationId": "64241",
      "callSign": "MNBCHD",
      "videoQuality": {
        "signalType": "Digital",
        "truResolution": "HD 1080i",
        "videoType": "HDTV"
      },
      "channel": "023",
      "preferredImage": {
        "width": "360",
        "height": "270",
        "uri": "http://wewe.tmsimg.com/assets/s64241_ll_h3_aa.png",
        "category": "Logo",
        "primary": "true"
      }
    },
    {
      "stationId": "58574",
      "callSign": "FXHD",
      "videoQuality": {
        "signalType": "Digital",
        "truResolution": "HD 720p",
        "videoType": "HDTV"
      },
      "channel": "040",
      "preferredImage": {
        "width": "360",
        "height": "270",
        "uri": "http://wewe.tmsimg.com/assets/s58574_ll_h3_aa.png",
        "category": "Logo",
        "primary": "true"
      }
    },
    {
      "stationId": "59337",
      "callSign": "AMCHD",
      "videoQuality": {
        "signalType": "Digital",
        "truResolution": "HD 1080i",
        "videoType": "HDTV"
      },
      "channel": "043",
      "preferredImage": {
        "width": "360",
        "height": "270",
        "uri": "http://wewe.tmsimg.com/assets/s59337_ll_h3_ab.png",
        "category": "Logo",
        "primary": "true"
      }
    },
    {
      "stationId": "73541",
      "callSign": "TVLNDHD",
      "videoQuality": {
        "signalType": "Digital",
        "truResolution": "HD 1080i",
        "videoType": "HDTV"
      },
      "channel": "034",
      "preferredImage": {
        "width": "360",
        "height": "270",
        "uri": "http://wewe.tmsimg.com/assets/s73541_ll_h3_aa.png",
        "category": "Logo",
        "primary": "true"
      }
    },
    {
      "stationId": "60150",
      "callSign": "LIFEHD",
      "videoQuality": {
        "signalType": "Digital",
        "truResolution": "HD 1080i",
        "videoType": "HDTV"
      },
      "channel": "045",
      "preferredImage": {
        "width": "360",
        "height": "270",
        "uri": "http://wewe.tmsimg.com/assets/s60150_h3_aa.png",
        "category": "Logo",
        "primary": "true"
      }
    },
    {
      "stationId": "56905",
      "callSign": "DSCHD",
      "videoQuality": {
        "signalType": "Digital",
        "truResolution": "HD 1080i",
        "videoType": "HDTV"
      },
      "channel": "027",
      "preferredImage": {
        "width": "360",
        "height": "270",
        "uri": "http://wewe.tmsimg.com/assets/s56905_ll_h3_ad.png",
        "category": "Logo",
        "primary": "true"
      }
    },
    {
      "stationId": "57391",
      "callSign": "TLCHD",
      "videoQuality": {
        "signalType": "Digital",
        "truResolution": "HD 1080i",
        "videoType": "HDTV"
      },
      "channel": "028",
      "preferredImage": {
        "width": "360",
        "height": "270",
        "uri": "http://wewe.tmsimg.com/assets/s57391_h3_aa.png",
        "category": "Logo",
        "primary": "true"
      }
    },
    {
      "stationId": "60046",
      "callSign": "VH1HD",
      "videoQuality": {
        "signalType": "Digital",
        "truResolution": "HD 1080i",
        "videoType": "HDTV"
      },
      "channel": "052",
      "preferredImage": {
        "width": "360",
        "height": "270",
        "uri": "http://wewe.tmsimg.com/assets/s60046_ll_h3_aa.png",
        "category": "Logo",
        "primary": "true"
      }
    },
    {
      "stationId": "59440",
      "callSign": "CMTVHD",
      "videoQuality": {
        "signalType": "Digital",
        "truResolution": "HD 1080i",
        "videoType": "HDTV"
      },
      "channel": "187",
      "preferredImage": {
        "width": "360",
        "height": "270",
        "uri": "http://wewe.tmsimg.com/assets/s59440_ll_h3_ad.png",
        "category": "Logo",
        "primary": "true"
      }
    },
    {
      "stationId": "64490",
      "callSign": "TRUTVHD",
      "videoQuality": {
        "signalType": "Digital",
        "truResolution": "HD 1080i",
        "videoType": "HDTV"
      },
      "channel": "058",
      "preferredImage": {
        "width": "360",
        "height": "270",
        "uri": "http://wewe.tmsimg.com/assets/s64490_ll_h3_ab.png",
        "category": "Logo",
        "primary": "true"
      }
    },
    {
      "stationId": "60964",
      "callSign": "MTVHD",
      "videoQuality": {
        "signalType": "Digital",
        "truResolution": "HD 1080i",
        "videoType": "HDTV"
      },
      "channel": "053",
      "preferredImage": {
        "width": "360",
        "height": "270",
        "uri": "http://wewe.tmsimg.com/assets/s60964_ll_h3_aa.png",
        "category": "Logo",
        "primary": "true"
      }
    },
    {
      "stationId": "26182",
      "callSign": "WNETDT",
      "videoQuality": {
        "signalType": "Digital",
        "truResolution": "HD 1080i",
        "videoType": "HDTV"
      },
      "affiliateCallSign": "PBS",
      "affiliateId": "11039",
      "channel": "013",
      "preferredImage": {
        "width": "360",
        "height": "270",
        "uri": "http://wewe.tmsimg.com/assets/s32356_h3_aa.png",
        "category": "Logo",
        "primary": "true"
      }
    },
    {
      "stationId": "59186",
      "callSign": "PARHD",
      "videoQuality": {
        "signalType": "Digital",
        "truResolution": "HD 1080i",
        "videoType": "HDTV"
      },
      "channel": "056",
      "preferredImage": {
        "width": "360",
        "height": "270",
        "uri": "http://wewe.tmsimg.com/assets/s59186_ll_h3_ac.png",
        "category": "Logo",
        "primary": "true"
      }
    },
    {
      "stationId": "49788",
      "callSign": "HGTVD",
      "videoQuality": {
        "signalType": "Digital",
        "truResolution": "HD 1080i",
        "videoType": "HDTV"
      },
      "channel": "098",
      "preferredImage": {
        "width": "360",
        "height": "270",
        "uri": "http://wewe.tmsimg.com/assets/s49788_h3_aa.png",
        "category": "Logo",
        "primary": "true"
      }
    },
    {
      "stationId": "70388",
      "callSign": "OWNHD",
      "videoQuality": {
        "signalType": "Digital",
        "truResolution": "HD 1080i",
        "videoType": "HDTV"
      },
      "channel": "180",
      "preferredImage": {
        "width": "360",
        "height": "270",
        "uri": "http://wewe.tmsimg.com/assets/s70388_ll_h3_aa.png",
        "category": "Logo",
        "primary": "true"
      }
    },
    {
      "stationId": "59250",
      "callSign": "CBSSNHD",
      "videoQuality": {
        "signalType": "Digital",
        "truResolution": "HD 1080i",
        "videoType": "HDTV"
      },
      "channel": "215",
      "preferredImage": {
        "width": "360",
        "height": "270",
        "uri": "http://wewe.tmsimg.com/assets/s59250_ll_h3_aa.png",
        "category": "Logo",
        "primary": "true"
      }
    },
    {
      "stationId": "60696",
      "callSign": "ESPNUHD",
      "videoQuality": {
        "signalType": "Digital",
        "truResolution": "HD 720p",
        "videoType": "HDTV"
      },
      "channel": "217",
      "preferredImage": {
        "width": "360",
        "height": "270",
        "uri": "http://wewe.tmsimg.com/assets/s60696_ll_h3_aa.png",
        "category": "Logo",
        "primary": "true"
      }
    },
    {
      "stationId": "48639",
      "callSign": "NBCSNHD",
      "videoQuality": {
        "signalType": "Digital",
        "truResolution": "HD 1080i",
        "videoType": "HDTV"
      },
      "channel": "212",
      "preferredImage": {
        "width": "360",
        "height": "270",
        "uri": "http://wewe.tmsimg.com/assets/s48639_ll_h3_aa.png",
        "category": "Logo",
        "primary": "true"
      }
    },
    {
      "stationId": "59684",
      "callSign": "DISNHD",
      "videoQuality": {
        "signalType": "Digital",
        "truResolution": "HD 720p",
        "videoType": "HDTV"
      },
      "channel": "031",
      "preferredImage": {
        "width": "360",
        "height": "270",
        "uri": "http://wewe.tmsimg.com/assets/s59684_ll_h3_ad.png",
        "category": "Logo",
        "primary": "true"
      }
    },
    {
      "stationId": "67331",
      "callSign": "NGWIHD",
      "videoQuality": {
        "signalType": "Digital",
        "truResolution": "HD 1080i",
        "videoType": "HDTV"
      },
      "channel": "158",
      "preferredImage": {
        "width": "360",
        "height": "270",
        "uri": "http://wewe.tmsimg.com/assets/s67331_ll_h3_ab.png",
        "category": "Logo",
        "primary": "true"
      }
    },
    {
      "stationId": "70522",
      "callSign": "OXYGNHD",
      "videoQuality": {
        "signalType": "Digital",
        "truResolution": "HD 1080i",
        "videoType": "HDTV"
      },
      "channel": "081",
      "preferredImage": {
        "width": "360",
        "height": "270",
        "uri": "http://wewe.tmsimg.com/assets/s70522_h3_aa.png",
        "category": "Logo",
        "primary": "true"
      }
    },
    {
      "stationId": "59444",
      "callSign": "IFCHD",
      "videoQuality": {
        "signalType": "Digital",
        "truResolution": "HD 1080i",
        "videoType": "HDTV"
      },
      "channel": "083",
      "preferredImage": {
        "width": "360",
        "height": "270",
        "uri": "http://wewe.tmsimg.com/assets/s59444_ll_h3_ab.png",
        "category": "Logo",
        "primary": "true"
      }
    },
    {
      "stationId": "35402",
      "callSign": "MSGHD",
      "videoQuality": {
        "signalType": "Digital",
        "truResolution": "HD 1080i",
        "videoType": "HDTV"
      },
      "channel": "087",
      "preferredImage": {
        "width": "360",
        "height": "270",
        "uri": "http://wewe.tmsimg.com/assets/s35402_ll_h3_ab.png",
        "category": "Logo",
        "primary": "true"
      }
    },
    {
      "stationId": "46275",
      "callSign": "YESHDNY",
      "videoQuality": {
        "signalType": "Digital",
        "truResolution": "HD 1080i",
        "videoType": "HDTV"
      },
      "channel": "089",
      "preferredImage": {
        "width": "360",
        "height": "270",
        "uri": "http://wewe.tmsimg.com/assets/s46275_ll_h3_aa.png",
        "category": "Logo",
        "primary": "true"
      }
    },
    {
      "stationId": "82547",
      "callSign": "FS1HD",
      "videoQuality": {
        "signalType": "Digital",
        "truResolution": "HD 720p",
        "videoType": "HDTV"
      },
      "channel": "099",
      "preferredImage": {
        "width": "360",
        "height": "270",
        "uri": "http://wewe.tmsimg.com/assets/s82547_ll_h3_aa.png",
        "category": "Logo",
        "primary": "true"
      }
    },
    {
      "stationId": "61812",
      "callSign": "EHD",
      "videoQuality": {
        "signalType": "Digital",
        "truResolution": "HD 1080i",
        "videoType": "HDTV"
      },
      "channel": "051",
      "preferredImage": {
        "width": "360",
        "height": "270",
        "uri": "http://wewe.tmsimg.com/assets/s61812_ll_h3_aa.png",
        "category": "Logo",
        "primary": "true"
      }
    },
    {
      "stationId": "65732",
      "callSign": "VICEHD",
      "videoQuality": {
        "signalType": "Digital",
        "truResolution": "HD 1080i",
        "videoType": "HDTV"
      },
      "channel": "161",
      "preferredImage": {
        "width": "360",
        "height": "270",
        "uri": "http://wewe.tmsimg.com/assets/s18822_h3_aa.png",
        "category": "Logo",
        "primary": "true"
      }
    }
  ]

  def up
    LIST.each do |n|
      network = Network.find_or_initialize_by(name: n[:callSign], display_name: n[:affiliateCallSign] || n[:callSign], station_id: n[:stationId])
      network.save
    end
  end
end

Network.each do |network|
  if network.display_name.blank?
    network.shows.each do |show|
      show.networks = []
      show.save
    end
    network.destroy
  end
end
