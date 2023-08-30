x1<-read.table("D:/essay/ElimDA/input/space.txt", header=TRUE, sep="\t")
library(ggplot2)
library(grid)

ggplot(x1, aes(x=nodetype, y=aver, group=methodtype, shape=methodtype, color=methodtype)) +
  # theme_bw() +
  scale_color_manual(name=element_blank(), 
                     breaks=c("a","b", "c","d","e","f"), 
                     values=c(a="#d428ff", b="#800080",c="#7c7a00", d="#adab00",e="#ff846d", f="#c00000"), 
                     labels=c("Plush-DARM","Plush-PMem","Viper-DRAM","Viper-PMem","ElimDA-DRAM", "ElimDA-PMem")) + 
  scale_linetype_manual(name=element_blank(), 
                        breaks=c("a", "b", "c", "d","e","f"),
                        values=c(a=2, b=1,c=2,d=1,e=2,f=1), 
                        labels=c("Plush-DARM","Plush-PMem","Viper-DRAM","Viper-PMem","ElimDA-DRAM", "ElimDA-PMem")) +
  scale_shape_manual(name=element_blank(),
                     values=c(5,20,1,4,9,18),
                     breaks=c("a","b", "c","d","e","f"),
                     labels=c("Plush-DARM","Plush-PMem","Viper-DRAM","Viper-PMem","ElimDA-DRAM", "ElimDA-PMem")) +
  scale_x_continuous(expand=c(0,0), limits=c(0,250), breaks=c(40, 80, 120, 160, 200, 240 )) +
  # scale_x_discrete(breaks=c("a", "b", "c", "d"), 
  #                  labels=c("1", "2", "4","8")) +
  scale_y_continuous(expand=c(0,0), limits=c(-0.6, 69), breaks=c(0, 2, 4, 6, 8)) +
  coord_cartesian(ylim = c(-0.6, 9)) + 
  geom_line(size=2, aes(linetype=methodtype,group=methodtype)) +
  geom_point(size=5, stroke=3, aes(shape=methodtype)) +
  geom_errorbar(aes(ymin=aver, ymax=aver), width=.1, position=position_dodge(0)) + 
  ylab("Space (GB)") +
  xlab("# of Inserts (Million)") +
  theme_classic() +
  theme_bw() +#去掉背景灰色
  theme(panel.grid.major=element_line(colour="grey"),   #网格线
        panel.background = element_rect(fill = "transparent",colour = NA),
        plot.background = element_rect(fill = "transparent",colour = NA),
        panel.grid.minor = element_blank()) +
  theme(axis.text.x = element_text(size=35, color="black")) +
  theme(axis.text.y = element_text(size=35, color="black")) +
  theme(legend.text = element_text(size=35)) +
  theme(axis.title.y = element_text(size=33)) + #,hjust=1
  theme(axis.title.x = element_text(size=33)) +
  #	theme(axis.text.x=element_text(angle=45, vjust=1, hjust=1)) +
  theme(legend.position="top", legend.direction="vertical", legend.key=element_rect(color="grey", size=1)) + 
  guides(color=guide_legend(nrow=2,ncol=3, byrow=FALSE,bycol=FALSE)) + 
  theme(legend.key.height = unit(35,"pt"),legend.key.width = unit(35,"pt")) +
  # remove border color of legend
  theme(legend.key = element_rect(colour = NA, fill = NA))
ggsave("D:/essay/ElimDA/output/space.pdf", width=11, height=5.5, device=cairo_pdf)