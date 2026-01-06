using PlateTags , Plots ,QRCoders, UUIDs, Test



chars = collect('a':'z')

randtext(n) = string(rand(chars,n)...)
tag1 = MicroTag("testmybacteria","testmyatccccccc")
tag2= MicroTag(randtext(30),randtext(24))
tag3 = MicroTag(randtext(30),randtext(24),date_field = false )
tag4 = MicroTag(randtext(25),randtext(24),QRCode(string(UUIDs.uuid4())))
tag5 = MicroTag(randtext(25),randtext(24),QRCode(string(UUIDs.uuid4())),date_field=false)


p1= plot(tag1)
p2 = plot(tag2)

savefig(p1, "plot1.pdf")
savefig(p2,"plot2.pdf")
savefig(plot(tag3),"plot3.pdf")
savefig(plot(tag4),"plot4.pdf")
savefig(plot(tag5),"plot5.pdf")


qr = QRCode(string(UUIDs.uuid4()))
ctag1 = CryoTag(fill(randtext(24),7);date_field = false )
ctag2 = CryoTag(fill(randtext(24),5),qr)
ctag3 = CryoTag(fill(randtext(24),6))
btag1 = BottleTag(fill(randtext(24),7);date_field=false)
btag2 = BottleTag(fill(randtext(24),6))






savefig(plot(ctag1),"cplot1.pdf")
savefig(plot(ctag2),"cplot2.pdf")
savefig(plot(ctag3),"cplot3.pdf")
savefig(plot(btag1),"bplot1.pdf")
savefig(plot(btag2),"bplot2.pdf")