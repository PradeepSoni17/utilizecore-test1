namespace :reports do
  desc 'Parcel-Report-Excel-file'
  task parcel_report_excel: :environment do
    puts "====== Parcle-Report-Generate On-#{Time.now.strftime('%d:%m:%Y-%H:%M')}==================="
  p = Axlsx::Package.new
  wb = p.workbook

  parcels =  Parcel.includes([:sender,:receiver, :service_type])
  wb.add_worksheet(:name => "Basic Worksheet") do |sheet|
    sheet.add_row ['Parcel Unique No', 'Weight','Status','Service Type','Payment Mode', 'Sender', 'Receiver']
    parcels.each do |p|
      sheet.add_row [p.unique_no, p.weight,p.status, p.service_type.name ,p.payment_mode, (p.sender.name rescue ''),(p.receiver.name rescue '')]
    end  
  end
  p.serialize("#{Rails.root}/public/reports/Parcel-Report-#{Time.now.strftime('%d:%m:%Y-%H:%M')}.xlsx")
  end

end
