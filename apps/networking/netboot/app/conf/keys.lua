local _M = {}

local keys = {
    ["Ask for Key"] = "",
    ["Windows 10/11 Home"] = "YTMG3-N6DKC-DKB77-7M9GH-8HVX7",
    ["Windows 10/11 Home N"] = "4CPRK-NM3K3-X6XXQ-RXX86-WXCHW",
    ["Windows 10/11 Pro"] = "VK7JG-NPHTM-C97JM-9MPGT-3V66T",
    ["Windows 10/11 Pro N"] = "2B87N-8KFHP-DKV6R-Y2C8J-PKCKT",
    ["Windows 10/11 Pro for Workstations"] = "DXG7C-N36C4-C4HTG-X4T3X-2YV77",
    ["Windows 10/11 Pro N for Workstations"] = "WYPNQ-8C467-V2W6J-TX4WX-WT2RQ",
    ["Windows 10/11 S"] = "3NF4D-GF9GY-63VKH-QRC3V-7QW8P",
    ["Windows 10/11 IoT Enterprise"] = "MNMRC-69F8V-2FCXX-GFQVY-BXQ3X",
    ["Windows 10/11 IoT Enterprise S"] = "JH8W6-VMNWP-6QBDM-PBP4B-J9FX9",
    ["Windows 10/11 ProfessionalEducation"] = "8PTT6-RNW4C-6V7J2-C2D3X-MHBPB",
    ["Windows 10/11 ProfessionalEducationN"] = "GJTYN-HDMQY-FRR76-HVGC7-QPF8P",
    ["Windows 10/11 ProfessionalStudent"] = "V3NH2-P462J-VT4G4-XD8DD-B973P",
    ["Windows 10/11 Education"] = "YNMGQ-8RYV3-4PGQ3-C8XTP-7CFBY",
    ["Windows 10/11 EducationN"] = "84NGF-MHBT6-FXBX8-QWJK7-DRR8H",
    ["Windows 10/11 Enterprise"] = "XGVPP-NMH47-7TTHJ-W3FW7-8HV2C",
    ["Windows 10/11 EnterpriseS"] = "NK96Y-D9CD8-W44CQ-R8YTK-DYJWX",
    ["Windows 10/11 EnterpriseSEval"] = "JBGN9-T2MH3-2YV7W-WBWHM-FGFCG",
    ["Windows 10/11 EnterpriseN"] = "WGGHN-J84D6-QYCPR-T7PJ7-X766F",
    ["Windows 10/11 EnterpriseSNEval"] = "7M88N-MTVMR-VC46G-4K4R6-KTQF7",
    ["KMS: Windows Server 2025 Standard"] = "TVRH6-WHNXV-R9WG3-9XRFY-MY832",
    ["KMS: Windows Server 2025 Datacenter"] = "D764K-2NDRG-47T6Q-P8T8W-YP6DF",
    ["KMS: Windows Server 2025 Datacenter: Azure Edition"] = "XGN3F-F394H-FD2MY-PP6FD-8MCRC",
    ["KMS: Windows Server 2022 Standard"] = "VDYBN-27WPP-V4HQT-9VMD4-VMK7H",
    ["KMS: Windows Server 2022 Datacenter"] = "WX4NM-KYWYW-QJJR4-XV3QB-6VM33",
    ["KMS: Windows Server 2022 Datacenter: Azure Edition"] = "NTBV8-9K7Q8-V27C6-M2BTV-KHMXV",
    ["KMS: Windows Server 2019 Standard"] = "N69G4-B89J2-4G8F4-WWYCC-J464C",
    ["KMS: Windows Server 2019 Datacenter"] = "WMDGN-G9PQG-XVVXX-R3X43-63DFG",
    ["KMS: Windows Server 2019 Essentials"] = "WVDHN-86M7X-466P6-VHXV7-YY726",
    ["KMS: Windows Server 2016 Standard"] = "WC2BQ-8NRM3-FDDYY-2BFGV-KHKQY",
    ["KMS: Windows Server 2016 Datacenter"] = "CB7KF-BWN84-R7R2Y-793K2-8XDDG",
    ["KMS: Windows Server 2016 Essentials"] = "JCKRF-N37P4-C2D82-9YXRT-4M63B",
    ["KMS: Windows Server 2022 (SAC) Standard"] = "N2KJX-J94YW-TQVFB-DG9YT-724CC",
    ["KMS: Windows Server 2022 (SAC) Datacenter"] = "6NMRW-2C8FM-D24W7-TQWMY-CWH2D",
    ["KMS: Windows 10/11 Pro"] = "W269N-WFGWX-YVC9B-4J6C9-T83GX",
    ["KMS: Windows 10/11 Pro N"] = "MH37W-N47XK-V7XM9-C7227-GCQG9",
    ["KMS: Windows 10/11 Pro for Workstations"] = "NRG8B-VKK3Q-CXVCJ-9G2XF-6Q84J",
    ["KMS: Windows 10/11 Pro Education"] = "6TP4R-GNPTD-KYYHQ-7B7DP-J447Y",
    ["KMS: Windows 10/11 Education"] = "NW6C2-QMPVW-D7KKK-3GKT6-VCFB2",
    ["KMS: Windows 10/11 Enterprise"] = "NPPR9-FWDCX-D2C8J-H872K-2YT43",
    ["KMS: Windows 10 Enterprise LTSC 2021"] = "M7XTQ-FN8P6-TTKYV-9D4CC-J462D",
    ["KMS: Windows 10 Enterprise LTSB 2016"] = "DCPHK-NFMTC-H88MJ-PFHPY-QJ4BJ",
    ["KMS: Windows 10 Enterprise LTSB 2015"] = "WNMTR-4C88C-JK8YV-HQ7T2-76DF9",
    ["KMS: Windows Server 2012 R2 Standard"] = "D2N9P-3P6X9-2R39C-7RTCD-MDVJX",
    ["KMS: Windows Server 2012 Datacenter"] = "W3GGN-FT8W3-Y4M27-J84CP-Q3VJ9",
    ["KMS: Windows Server 2008 R2 Web"] = "6TPJF-RBVHG-WBW2R-86QPH-6RTM4",
    ["KMS: Windows Server 2008 R2 Standard"] = "YC6KT-GKW9T-YTKYR-T4X34-R7VHC",
    ["KMS: Windows 8.1 Pro"] = "GCRJD-8NW9H-F2CDX-CCM8D-9D6T9",
    ["KMS: Windows 8 Pro"] = "NG4HW-VH26C-733KW-K6F98-J8CK4",
    ["KMS: Windows 7 Professional"] = "FJ82H-XT6CR-J8D7P-XQJJ2-GPDD4",
    ["KMS: Windows Vista Business"] = "YFKBB-PQJJV-G996G-VWGXY-2V3X8"
}

function _M.getKeys()
    return keys
end

function _M.getKeyList()
    local keyset={}

    for k,_ in pairs(keys) do
      keyset[#keyset + 1]=k
    end

    return keyset
end

return _M
