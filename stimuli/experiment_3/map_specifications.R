maps = c(
  "D1_0",
  "D1_1",
  "D1_2",
  "D2_0",
  "D2_1",
  "D2_2",
  "P1_0",
  "P1_1",
  "P1_2",
  "P2_0",
  "P2_1",
  "P2_2",
  "UN_0",
  "UN_1",
  "UN_2"
)

segments = list(
  # D1_0
  c(
    geom_segment(aes(x=9.5, xend=9.5, y=5.5, yend=2.5)),
    geom_segment(aes(x=9.5, xend=9.5, y=9.5, yend=6.5)),
    geom_segment(aes(x=2.5, xend=9.5, y=2.5, yend=2.5)),
    geom_segment(aes(x=2.5, xend=2.5, y=2.5, yend=9.5)),
    geom_segment(aes(x=2.5, xend=9.5, y=9.5, yend=9.5))
  ),
  # D1_1
  c(
    geom_segment(aes(x=9.5, xend=9.5, y=9.5, yend=2.5)),
    geom_segment(aes(x=2.5, xend=6.5, y=2.5, yend=2.5)),
    geom_segment(aes(x=7.5, xend=9.5, y=2.5, yend=2.5)),
    geom_segment(aes(x=2.5, xend=2.5, y=2.5, yend=9.5)),
    geom_segment(aes(x=2.5, xend=9.5, y=9.5, yend=9.5))
  ),
  # D1_2
  c(
    geom_segment(aes(x=9.5, xend=9.5, y=2.5, yend=5.5)),
    geom_segment(aes(x=9.5, xend=9.5, y=6.5, yend=9.5)),
    geom_segment(aes(x=2.5, xend=9.5, y=2.5, yend=9.5)),
    geom_segment(aes(x=2.5, xend=2.5, y=9.5, yend=6.5)),
    geom_segment(aes(x=2.5, xend=2.5, y=2.5, yend=5.5)),
    geom_segment(aes(x=2.5, xend=9.5, y=9.5, yend=9.5))
  ),
  # D2_0
  c(
    geom_segment(aes(x=9.5, xend=9.5, y=2.5, yend=5.5)),
    geom_segment(aes(x=9.5, xend=9.5, y=6.5, yend=9.5)),
    geom_segment(aes(x=2.5, xend=9.5, y=2.5, yend=2.5)),
    geom_segment(aes(x=2.5, xend=2.5, y=2.5, yend=9.5)),
    geom_segment(aes(x=2.5, xend=9.5, y=9.5, yend=9.5))
  ),
  # D2_1
  c(
    geom_segment(aes(x=9.5, xend=9.5, y=2.5, yend=5.5)),
    geom_segment(aes(x=9.5, xend=9.5, y=6.5, yend=9.5)),
    geom_segment(aes(x=2.5, xend=9.5, y=2.5, yend=2.5)),
    geom_segment(aes(x=2.5, xend=2.5, y=2.5, yend=9.5)),
    geom_segment(aes(x=2.5, xend=9.5, y=9.5, yend=9.5))
  ),
  # D2_2
  c(
    geom_segment(aes(x=9.5, xend=9.5, y=2.5, yend=9.5)),
    geom_segment(aes(x=2.5, xend=5.5, y=2.5, yend=2.5)),
    geom_segment(aes(x=6.5, xend=9.5, y=2.5, yend=2.5)),
    geom_segment(aes(x=2.5, xend=2.5, y=9.5, yend=6.5)),
    geom_segment(aes(x=2.5, xend=2.5, y=2.5, yend=5.5)),
    geom_segment(aes(x=2.5, xend=9.5, y=9.5, yend=9.5))
  ),
  # P1_0
  c(
    geom_segment(aes(x=9.5, xend=9.5, y=2.5, yend=5.5)),
    geom_segment(aes(x=9.5, xend=9.5, y=6.5, yend=9.5)),
    geom_segment(aes(x=2.5, xend=9.5, y=2.5, yend=2.5)),
    geom_segment(aes(x=2.5, xend=2.5, y=2.5, yend=9.5)),
    geom_segment(aes(x=2.5, xend=9.5, y=9.5, yend=9.5))
  ),
  # P1_1
  c(
    geom_segment(aes(x=9.5, xend=9.5, y=2.5, yend=5.5)),
    geom_segment(aes(x=9.5, xend=9.5, y=6.5, yend=9.5)),
    geom_segment(aes(x=2.5, xend=9.5, y=2.5, yend=2.5)),
    geom_segment(aes(x=2.5, xend=2.5, y=2.5, yend=9.5)),
    geom_segment(aes(x=2.5, xend=9.5, y=9.5, yend=9.5))
  ),
  # P1_2
  c(
    geom_segment(aes(x=9.5, xend=9.5, y=2.5, yend=9.5)),
    geom_segment(aes(x=2.5, xend=9.5, y=2.5, yend=2.5)),
    geom_segment(aes(x=2.5, xend=2.5, y=2.5, yend=7.5)),
    geom_segment(aes(x=2.5, xend=2.5, y=8.5, yend=9.5)),
    geom_segment(aes(x=2.5, xend=7.5, y=9.5, yend=9.5)),
    geom_segment(aes(x=8.5, xend=9.5, y=9.5, yend=9.5))
  ),
  # P2_0
  c(
    geom_segment(aes(x=9.5, xend=9.5, y=2.5, yend=7.5)),
    geom_segment(aes(x=9.5, xend=9.5, y=8.5, yend=9.5)),
    geom_segment(aes(x=2.5, xend=9.5, y=2.5, yend=2.5)),
    geom_segment(aes(x=2.5, xend=2.5, y=2.5, yend=9.5)),
    geom_segment(aes(x=2.5, xend=9.5, y=9.5, yend=9.5))
  ),
  # P2_1
  c(
    geom_segment(aes(x=9.5, xend=9.5, y=2.5, yend=9.5)),
    geom_segment(aes(x=2.5, xend=9.5, y=2.5, yend=2.5)),
    geom_segment(aes(x=2.5, xend=2.5, y=2.5, yend=9.5)),
    geom_segment(aes(x=2.5, xend=7.5, y=9.5, yend=9.5)),
    geom_segment(aes(x=8.5, xend=9.5, y=9.5, yend=9.5))
  ),
  # P2_2
  c(
    geom_segment(aes(x=9.5, xend=9.5, y=2.5, yend=5.5)),
    geom_segment(aes(x=9.5, xend=9.5, y=6.5, yend=9.5)),
    geom_segment(aes(x=2.5, xend=9.5, y=2.5, yend=2.5)),
    geom_segment(aes(x=2.5, xend=2.5, y=2.5, yend=9.5)),
    geom_segment(aes(x=2.5, xend=5.5, y=9.5, yend=9.5)),
    geom_segment(aes(x=6.5, xend=9.5, y=9.5, yend=9.5))
  ),
  # UN_0
  c(
    geom_segment(aes(x=9.5, xend=9.5, y=2.5, yend=9.5)),
    geom_segment(aes(x=2.5, xend=9.5, y=2.5, yend=2.5)),
    geom_segment(aes(x=2.5, xend=2.5, y=2.5, yend=9.5)),
    geom_segment(aes(x=2.5, xend=5.5, y=9.5, yend=9.5)),
    geom_segment(aes(x=6.5, xend=9.5, y=9.5, yend=9.5))
  ),
  # UN_1
  c(
    geom_segment(aes(x=9.5, xend=9.5, y=2.5, yend=5.5)),
    geom_segment(aes(x=9.5, xend=9.5, y=6.5, yend=9.5)),
    geom_segment(aes(x=2.5, xend=9.5, y=2.5, yend=2.5)),
    geom_segment(aes(x=2.5, xend=2.5, y=2.5, yend=9.5)),
    geom_segment(aes(x=2.5, xend=9.5, y=9.5, yend=9.5))
  ),
  # UN_2
  c(
    geom_segment(aes(x=9.5, xend=9.5, y=2.5, yend=4.5)),
    geom_segment(aes(x=9.5, xend=9.5, y=5.5, yend=9.5)),
    geom_segment(aes(x=2.5, xend=9.5, y=2.5, yend=2.5)),
    geom_segment(aes(x=2.5, xend=2.5, y=2.5, yend=9.5)),
    geom_segment(aes(x=2.5, xend=4.5, y=9.5, yend=9.5)),
    geom_segment(aes(x=5.5, xend=9.5, y=9.5, yend=9.5))
  )
)

walls = list(
  # D1_0
  c(),
  # D1_1
  c(),
  # D1_2
  c(),
  # D2_0
  c(),
  # D2_1
  c(),
  # D2_2
  c(),
  # P1_0
  c(),
  # P1_1
  c(
    geom_rect(aes(xmin=6.5, xmax=7.5, ymin=4.5, ymax=5.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=6.5, xmax=7.5, ymin=5.5, ymax=6.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=7.5, xmax=8.5, ymin=4.5, ymax=5.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=8.5, xmax=9.5, ymin=4.5, ymax=5.5, fill="gray"), alpha=1)
  ),
  # P1_2
  c(),
  # P2_0
  c(),
  # P2_1
  c(
    geom_rect(aes(xmin=4.5, xmax=5.5, ymin=3.5, ymax=4.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=5.5, xmax=6.5, ymin=3.5, ymax=4.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=6.5, xmax=7.5, ymin=3.5, ymax=4.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=7.5, xmax=8.5, ymin=3.5, ymax=4.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=8.5, xmax=9.5, ymin=3.5, ymax=4.5, fill="gray"), alpha=1)
  ),
  # P2_2
  c(),
  # UN_0
  c(),
  # UN_1
  c(
    geom_rect(aes(xmin=6.5, xmax=7.5, ymin=4.5, ymax=5.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=7.5, xmax=8.5, ymin=4.5, ymax=5.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=8.5, xmax=9.5, ymin=4.5, ymax=5.5, fill="gray"), alpha=1)
  ),
  # UN_2
  c()
)
