d <- read.csv("pilot_longer.csv")

d$option <- factor(d$option)
d.summary <- summarySE(d, measurevar="rating", groupvars=c("quality", "discourseOrder", "option", "description"))
d.summary$option <- factor(d.summary$option, labels=c("first", "second"))
ggplot(d.summary, aes(x=option, y=rating, fill=description)) +
  geom_bar(stat="identity", color="black", position=position_dodge()) +
  geom_errorbar(aes(ymin=rating-ci, ymax=rating+ci), position=position_dodge(0.9), width=0.5) +
  theme_bw() +
  facet_grid(quality~discourseOrder) +
  xlab("order")

ggplot(subset(d, quality=="tall"), aes(x=option, y=rating, color=discourseOrder)) +
  geom_point() +
  theme_bw() +
  facet_wrap(~workerID, ncol=5)