import Foundation

extension Components.Schemas.SMC {    
    func print(withNumber: Bool = true, withDate: Bool = true) -> Void {
        Swift.print()
        
        if withNumber {
            Swift.print("#", id)
        }

        if withDate {
            Swift.print(date.formatted(date: .long, time: .shortened), terminator: "\n\n")
        }
        
        Swift.print(content, terminator: "\n\n")
    }
}

extension Components.Schemas.Page.metadataPayload {
    var last: UInt {
        guard per! > 0 && total! > 0 else {
            return 1
        }
        
        return UInt((Float(total!) / Float(per!)).rounded(.up))
    }
}

extension Components.Schemas.Page {
    func print(withNumber: Bool = true, withDate: Bool = true) -> Void {
        Swift.print()

        for record in items! {
            switch record {
        
            case .SMC(let smc):
                smc.print(withNumber: withNumber, withDate: withDate)
                
                for _ in 1...9 { Swift.print("-", terminator: "") }
                
                Swift.print()
            }
        }

        Swift.print()

        Swift.print(
            "PAGE:",
            " ",
            metadata!.page!,
            "/",
            metadata!.last,
            separator: "",
            terminator: "\n\n"
        )
    }
}
