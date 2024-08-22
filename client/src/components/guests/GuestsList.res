@val
external navigator: {"clipboard": {"writeText": string => Promise.t<unit>}} = "navigator"

let copyToClipboard = (text: string) => {
  navigator["clipboard"]["writeText"](text)->ignore
}
@react.component
let make = (~guests: array<Models.Guest.t>) => {
  <div className="flex flex-col bg-white rounded-2xl" style={{height: "calc(100vh - 1rem)"}}>
    <div className="flex justify-between items-center p-4 border-b border-gray-100">
      <h1 className="text-xl font-semibold text-gray-950"> {React.string("Guest List")} </h1>
      <GuestDialog />
    </div>
    <div className="flex-1 overflow-y-auto">
      <ul role="list" className="divide-y divide-gray-100 m-4 border border-gray-100 rounded-2xl">
        {Array.map(guests, g => {
          let address = switch g.address_line_2 {
          | Some(line2) => g.address_line_1 ++ ", " ++ line2
          | None => g.address_line_1
          }

          let status = switch g.rsvp_status {
          | #not_invited => "Not Invited"
          | #invited => "Invited"
          | #accepted => "Accepted"
          | #declined => "Declined"
          }
          let color = switch g.rsvp_status {
          | #not_invited => #gray
          | #invited => #yellow
          | #accepted => #green
          | #declined => #red
          }

          <li key={g.id} className="flex items-center justify-between gap-x-6 p-4">
            <div className="min-w-0">
              <div className="flex items-start gap-x-3">
                <p className="text-sm font-semibold leading-6 text-gray-900">
                  {React.string(g.first_name ++ " " ++ g.last_name)}
                </p>
                <Ui.Badge label=status color />
              </div>
              <div className="mt-1 flex items-center gap-x-2 text-xs leading-5 text-gray-500">
                <p className="whitespace-nowrap"> {React.string(address)} </p>
                <svg viewBox="0 0 2 2" className="h-0.5 w-0.5 fill-current">
                  <circle r="1" cx="1" cy="1" />
                </svg>
                <p className="truncate"> {React.string(Utils.formatDateString(g.inserted_at))} </p>
              </div>
            </div>
            <div className="flex flex-none items-center gap-x-1">
              <Ui.ButtonTooltip
                label="Copy Email" icon="email" onClick={_ => copyToClipboard(g.email)}
              />
              <Ui.ButtonTooltip
                label={`Edit ${g.first_name} ${g.last_name}`}
                icon="edit"
                onClick={_ => Console.log("editing")}
              />
              <Ui.ButtonTooltip
                label={`Delete ${g.first_name} ${g.last_name}`}
                icon="trash"
                color=#red
                onClick={_ => Console.log("deleting")}
              />
            </div>
          </li>
        })->React.array}
      </ul>
    </div>
    <div className="p-4 border-t border-gray-100"> {React.string("extras")} </div>
  </div>
}