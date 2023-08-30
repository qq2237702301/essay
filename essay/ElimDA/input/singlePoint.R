# getwd()
# install.packages("readxl")
# install.packages("reshape2")
# install.packages("Hmisc")
# install.packages("lemon")
library(Hmisc)  
library(lemon)
library(readxl)
library(ggplot2)
x1<-read.table("D:/essay/ElimDA/input/ycsb-a.txt", header=TRUE, sep="\t")
x2<-read.table("D:/essay/ElimDA/input/ycsb-b.txt", header=TRUE, sep="\t")
x3<-read.table("D:/essay/ElimDA/input/ycsb-d.txt", header=TRUE, sep="\t")
x4<-read.table("D:/essay/ElimDA/input/ycsb-f.txt", header=TRUE, sep="\t")
type <- c('A','B','C','D','E')
quanlity <- c(1,1.1,2.1,1.5,1.7)
df <- data.frame(type = type, quanlity = quanlity)
q1<-ggplot(x1, aes(x=nodetype, y=aver, group=methodtype, shape=methodtype, color=methodtype)) +
  scale_color_manual(name=element_blank(), 
                     breaks=c("a","b", "c", "d", "e","f","g"), 
                     values=c(a="#63b235", b="#ed7d31", c="#5A5AAD", d="#2e75b6", e="#800080",f="#adab00",g="#c00000"), 
                     labels=c("DASH", "CCEH", "Level", "Clevel", "Plush", "Viper" ,"ElimDA")) + 
  scale_shape_manual(name=element_blank(),
                     values=c(3,17,16,4,21,6,18),
                     breaks=c("a", "b","c", "d", "e", "f","g"),
                     labels=c("DASH", "CCEH", "Level", "Clevel", "Plush" ,"Viper","ElimDA")) +
  scale_x_continuous(expand=c(0,0), limits=c(0,25), breaks=c(1, 2, 4, 8, 16, 24))+
  scale_y_continuous(expand=c(0,0), limits=c(0, 27.5), breaks=c(0, 5, 10, 15, 20, 25))+
  geom_point(size=5, stroke=3, aes(shape=methodtype)) +
  ylab("Throughput (Mops/s)") +
  xlab("# of Threads") +
  theme_classic() +
  theme_bw() 
  theme(panel.grid.major=element_line(colour="grey"),
        panel.background = element_rect(fill = "transparent",colour = NA),
        plot.background = element_rect(fill = "transparent",colour = NA),
        panel.grid.minor = element_blank()) +
  theme(axis.text.x = element_text(size=20)) +
  theme(axis.text.y = element_text(size=20)) +
  theme(legend.text = element_text(size=20)) +
  theme(axis.title = element_text(size=20)) +
  theme(axis.title.x = element_text(size=23)) + 
  
  theme(legend.position=c(0.5, 1), legend.direction="vertical", legend.key=element_rect(color="grey", size=1)) + 
  guides(color=guide_legend(nrow=1, byrow=FALSE)) + 
  theme(legend.key.height = unit(35,"pt"),legend.key.width = unit(35,"pt")) +
  
  theme(legend.key = element_rect(colour = NA, fill = NA), legend.box.background = element_blank()) + 
  theme(panel.grid.major=element_line(colour="grey"),
        panel.background = element_rect(fill = "transparent",colour = NA),
        plot.background = element_rect(fill = "transparent",colour = NA),
        panel.grid.minor = element_blank(),#以上theme中代码用于去除网格线且保留坐标轴边框
  )
q5<-grid_arrange_shared_legend(q1, ncol = 1, nrow = 1,position='top')
ggsave("D:/essay/ElimDA/output/uniform.pdf", q5, width=10, height=5.5, device=cairo_pdf)