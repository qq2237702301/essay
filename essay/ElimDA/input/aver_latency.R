# library(remotes)
# remotes::install_version("Rttf2pt1", version = "1.3.8")
# library(extrafont)
# loadfonts(device = "win")
windowsFonts(A=windowsFont("Arial"))
x1<-read.table("C:/Users/yzx/Desktop/ElimDA_Paper/ICDE/evaluation/Latency/aver_latency.txt", header=TRUE,  sep="\t")
library(ggplot2)
library(grid)
library(extrafont)

library(ggpattern)
library(ggbreak)

# font_import()
# loadfonts()

ggplot(x1, aes(x=codetype, y=aver, fill=methodtype)) + 
  #geom_rect(aes(xmin=0, xmax=6, ymin=42, ymax=48), fill="white")
  geom_bar_pattern(stat = "identity", 
                   pattern = rep(c("stripe", "crosshatch","circle", "stripe", "stripe","crosshatch"),4),
                   pattern_angle = rep(c(rep(45, 1), rep(0,1), rep(135,1), rep(0, 1), rep(135,1), rep(135, 1)),4),
                   #pattern_angle=45,
                   pattern_density = .1,
                   pattern_spacing = .03,
                   pattern_fill = 'black',
                   aes(fill = methodtype), 
                   position = position_dodge(),
                   color="black",
                   size=1, width = 0.85) +
  scale_fill_manual(name=element_blank(),
                    values=c(a="#63b235", b="#ed7d31", c="#5A5AAD", d="#2e75b6", e="#800080",f="#c00000"),
                    breaks=c("a", "b", "c", "d", "e", "f"),
                    labels=c("DASH", "CCEH", "Level", "Clevel", "Plush","ElimDA")) +
  scale_x_discrete(breaks=c("a", "b", "c", "d"),
                   labels=c("Insert","Search(P)", "Search(N)", "Delete")) +
  #labels=c("stg_1","mds_1", "prn_1","proj_4", "src1_1", "2016021810-LUN2", "2016022008-LUN0", "2016021712-LUN3","2016021909-LUN6","2016021918-LUN3")) +
  scale_y_continuous(expand=c(0,0), limits=c(0,9),breaks=c(0, 2, 4, 6, 8)) +
  #scale_y_cut(breaks = 5,which = c(1,3),scales = c(3,0.5),space = 0.1) +
  # geom_bar(color="black", stat="identity", width=0.8, position=position_dodge()) +
  geom_errorbar(aes(ymin=min, ymax=max), width=0.4, position=position_dodge(.85))+
  geom_text(aes(label=sprintf("%.1f", round(aver, digits = 1)) ), position=position_dodge(.85),hjust=0.5, vjust=-0.5, size=6.5, angle=0) +
  guides(fill=guide_legend(override.aes = 
                               list(
                                 pattern = c("stripe", "crosshatch", "circle", "stripe", "stripe", "crosshatch"),
                                 pattern_spacing = 0.05,
                                 pattern_angle = c(45, 0, 135, 0, 135,135)
                               ), nrow=2, byrow=FALSE, keywidth=3, keyheight=1.5, position="left"))+
  ylab("Latency (μs)")+ 
  xlab(NULL)+
  #annotate("text", x = 1.5 , y = 4.3,label = "7.1μs",colour="black",size=8) + 
  #geom_segment(mapping = aes(x=1.4, y=4.2, xend=1.3, yend=4.5), arrow = arrow(length=unit(0.2, "cm"))) +   #箭头
  theme_classic() +
  theme_bw() +#去掉背景灰色
  theme(panel.grid.major=element_line(colour=NA),
        panel.background = element_rect(fill = "transparent",colour = NA),
        plot.background = element_rect(fill = "transparent",colour = NA),
        panel.grid.minor = element_blank()) +
  theme(axis.text.x = element_text(angle=0, size=18, hjust=0.5, vjust=0.5, color="black")) +
  theme(axis.text.y = element_text(size=18)) +
  #	theme(axis.title.x = element_blank()) +
  theme(axis.title = element_text(size=18)) + 
  #increase the space between the x-axis title and x-axis text
  theme(axis.title.x = element_text(margin = unit(c(4, 0, 0, 0), "mm")))+ 
  # theme(axis.title.y = element_text(size=25)) +  
  theme(legend.text = element_text(size=18)) +
  theme(legend.position=c(0.75, 0.810), legend.direction="horizontal", legend.key=element_rect(color="grey", size=0.25))
  # + theme(legend.text = element_text(margin = margin(r = 5, unit = "pt")))
  ggsave("C:/Users/yzx/Desktop/ElimDA_Paper/ICDE/evaluation/Latency/aver_latency.pdf", width=10, height=2.5, device=cairo_pdf)
  # theme_get()$text