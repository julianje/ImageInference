maps = c(
  "DX_DX_0",
  "DX_NX_0",
  "DX_PX_0",
  "DX_UN_0",
  "ND_DX_0",
  "ND_DX_1",
  "ND_NX_0",
  "ND_NX_1",
  "ND_PX_0",
  "ND_PX_1",
  "ND_UN_0",
  "NX_DX_0",
  "NX_NX_0",
  "NX_PX_0",
  "NX_UN_0",
  "PX_DX_0",
  "PX_NX_0",
  "PX_PX_0",
  "PX_UN_0",
  "UN_DX_0",
  "UN_NX_0",
  "UN_PX_0",
  "UN_UN_0"
)

segments = list(
  # DX_DX_0
  c(
    geom_segment(aes(x=9.5, xend=9.5, y=9.5, yend=2.5)),
    geom_segment(aes(x=2.5, xend=5.5, y=2.5, yend=2.5)),
    geom_segment(aes(x=6.5, xend=9.5, y=2.5, yend=2.5)),
    geom_segment(aes(x=2.5, xend=2.5, y=2.5, yend=5.5)),
    geom_segment(aes(x=2.5, xend=2.5, y=6.5, yend=9.5)),
    geom_segment(aes(x=2.5, xend=9.5, y=9.5, yend=9.5))
  ),
  # DX_NX_0
  c(
    geom_segment(aes(x=9.5, xend=9.5, y=9.5, yend=2.5)),
    geom_segment(aes(x=2.5, xend=5.5, y=2.5, yend=2.5)),
    geom_segment(aes(x=6.5, xend=9.5, y=2.5, yend=2.5)),
    geom_segment(aes(x=2.5, xend=2.5, y=2.5, yend=9.5)),
    geom_segment(aes(x=2.5, xend=5.5, y=9.5, yend=9.5)),
    geom_segment(aes(x=6.5, xend=9.5, y=9.5, yend=9.5))
  ),
  # DX_PX_0
  c(
    geom_segment(aes(x=9.5, xend=9.5, y=9.5, yend=8.5)),
    geom_segment(aes(x=9.5, xend=9.5, y=7.5, yend=2.5)),
    geom_segment(aes(x=2.5, xend=4.5, y=2.5, yend=2.5)),
    geom_segment(aes(x=5.5, xend=9.5, y=2.5, yend=2.5)),
    geom_segment(aes(x=2.5, xend=2.5, y=2.5, yend=9.5)),
    geom_segment(aes(x=2.5, xend=9.5, y=9.5, yend=9.5))
  ),
  # DX_UN_0
  c(
    geom_segment(aes(x=9.5, xend=9.5, y=9.5, yend=2.5)),
    geom_segment(aes(x=9.5, xend=2.5, y=2.5, yend=2.5)),
    geom_segment(aes(x=2.5, xend=2.5, y=2.5, yend=3.5)),
    geom_segment(aes(x=2.5, xend=2.5, y=4.5, yend=9.5)),
    geom_segment(aes(x=2.5, xend=5.5, y=9.5, yend=9.5)),
    geom_segment(aes(x=6.5, xend=9.5, y=9.5, yend=9.5))
  ),
  # ND_DX_0
  c(
    geom_segment(aes(x=9.5, xend=9.5, y=9.5, yend=6.5)),
    geom_segment(aes(x=9.5, xend=9.5, y=5.5, yend=2.5)),
    geom_segment(aes(x=2.5, xend=9.5, y=2.5, yend=2.5)),
    geom_segment(aes(x=2.5, xend=2.5, y=2.5, yend=9.5)),
    geom_segment(aes(x=2.5, xend=9.5, y=9.5, yend=9.5))
  ),
  # ND_DX_1
  c(
    geom_segment(aes(x=9.5, xend=9.5, y=9.5, yend=4.5)),
    geom_segment(aes(x=9.5, xend=9.5, y=3.5, yend=2.5)),
    geom_segment(aes(x=2.5, xend=9.5, y=2.5, yend=2.5)),
    geom_segment(aes(x=2.5, xend=2.5, y=2.5, yend=9.5)),
    geom_segment(aes(x=2.5, xend=9.5, y=9.5, yend=9.5))
  ),
  # ND_NX_0
  c(
    geom_segment(aes(x=9.5, xend=9.5, y=9.5, yend=6.5)),
    geom_segment(aes(x=9.5, xend=9.5, y=5.5, yend=2.5)),
    geom_segment(aes(x=2.5, xend=9.5, y=2.5, yend=2.5)),
    geom_segment(aes(x=2.5, xend=2.5, y=2.5, yend=9.5)),
    geom_segment(aes(x=2.5, xend=9.5, y=9.5, yend=9.5))
  ),
  # ND_NX_1
  c(
    geom_segment(aes(x=9.5, xend=9.5, y=9.5, yend=4.5)),
    geom_segment(aes(x=9.5, xend=9.5, y=3.5, yend=2.5)),
    geom_segment(aes(x=2.5, xend=9.5, y=2.5, yend=2.5)),
    geom_segment(aes(x=2.5, xend=2.5, y=2.5, yend=9.5)),
    geom_segment(aes(x=2.5, xend=9.5, y=9.5, yend=9.5))
  ),
  # ND_PX_0
  c(
    geom_segment(aes(x=9.5, xend=9.5, y=9.5, yend=4.5)),
    geom_segment(aes(x=9.5, xend=9.5, y=3.5, yend=2.5)),
    geom_segment(aes(x=2.5, xend=9.5, y=2.5, yend=2.5)),
    geom_segment(aes(x=2.5, xend=2.5, y=2.5, yend=9.5)),
    geom_segment(aes(x=2.5, xend=9.5, y=9.5, yend=9.5))
  ),
  # ND_PX_1
  c(
    geom_segment(aes(x=9.5, xend=9.5, y=2.5, yend=4.5)),
    geom_segment(aes(x=9.5, xend=9.5, y=5.5, yend=9.5)),
    geom_segment(aes(x=2.5, xend=9.5, y=2.5, yend=2.5)),
    geom_segment(aes(x=2.5, xend=9.5, y=9.5, yend=9.5)),
    geom_segment(aes(x=2.5, xend=2.5, y=2.5, yend=9.5))
  ),
  # ND_UN_0
  c(
    geom_segment(aes(x=9.5, xend=9.5, y=2.5, yend=7.5)),
    geom_segment(aes(x=9.5, xend=9.5, y=8.5, yend=9.5)),
    geom_segment(aes(x=2.5, xend=9.5, y=2.5, yend=2.5)),
    geom_segment(aes(x=2.5, xend=2.5, y=2.5, yend=9.5)),
    geom_segment(aes(x=2.5, xend=9.5, y=9.5, yend=9.5))
  ),
  # NX_DX_0
  c(
    geom_segment(aes(x=9.5, xend=9.5, y=9.5, yend=6.5)),
    geom_segment(aes(x=9.5, xend=9.5, y=5.5, yend=2.5)),
    geom_segment(aes(x=2.5, xend=9.5, y=2.5, yend=2.5)),
    geom_segment(aes(x=2.5, xend=2.5, y=2.5, yend=5.5)),
    geom_segment(aes(x=2.5, xend=2.5, y=6.5, yend=9.5)),
    geom_segment(aes(x=2.5, xend=7.5, y=9.5, yend=9.5)),
    geom_segment(aes(x=8.5, xend=9.5, y=9.5, yend=9.5))
  ),
  # NX_NX_0
  c(
    geom_segment(aes(x=9.5, xend=9.5, y=2.5, yend=4.5)),
    geom_segment(aes(x=9.5, xend=9.5, y=5.5, yend=9.5)),
    geom_segment(aes(x=2.5, xend=6.5, y=9.5, yend=9.5)),
    geom_segment(aes(x=7.5, xend=9.5, y=9.5, yend=9.5)),
    geom_segment(aes(x=2.5, xend=2.5, y=2.5, yend=9.5)),
    geom_segment(aes(x=2.5, xend=3.5, y=2.5, yend=2.5)),
    geom_segment(aes(x=4.5, xend=9.5, y=2.5, yend=2.5))
  ),
  # NX_PX_0
  c(
    geom_segment(aes(x=9.5, xend=9.5, y=2.5, yend=6.5)),
    geom_segment(aes(x=9.5, xend=9.5, y=7.5, yend=9.5)),
    geom_segment(aes(x=2.5, xend=6.5, y=9.5, yend=9.5)),
    geom_segment(aes(x=7.5, xend=9.5, y=9.5, yend=9.5)),
    geom_segment(aes(x=2.5, xend=2.5, y=2.5, yend=3.5)),
    geom_segment(aes(x=2.5, xend=2.5, y=4.5, yend=9.5)),
    geom_segment(aes(x=2.5, xend=9.5, y=2.5, yend=2.5))
  ),
  # NX_UN_0
  c(
    geom_segment(aes(x=9.5, xend=9.5, y=9.5, yend=6.5)),
    geom_segment(aes(x=9.5, xend=9.5, y=5.5, yend=2.5)),
    geom_segment(aes(x=2.5, xend=9.5, y=2.5, yend=2.5)),
    geom_segment(aes(x=2.5, xend=2.5, y=2.5, yend=5.5)),
    geom_segment(aes(x=2.5, xend=2.5, y=6.5, yend=9.5)),
    geom_segment(aes(x=2.5, xend=7.5, y=9.5, yend=9.5)),
    geom_segment(aes(x=8.5, xend=9.5, y=9.5, yend=9.5))
  ),
  # PX_DX_0
  c(
    geom_segment(aes(x=9.5, xend=9.5, y=9.5, yend=2.5)),
    geom_segment(aes(x=2.5, xend=5.5, y=2.5, yend=2.5)),
    geom_segment(aes(x=6.5, xend=9.5, y=2.5, yend=2.5)),
    geom_segment(aes(x=2.5, xend=2.5, y=2.5, yend=4.5)),
    geom_segment(aes(x=2.5, xend=2.5, y=5.5, yend=9.5)),
    geom_segment(aes(x=2.5, xend=7.5, y=9.5, yend=9.5)),
    geom_segment(aes(x=8.5, xend=9.5, y=9.5, yend=9.5))
  ),
  # PX_NX_0
  c(
    geom_segment(aes(x=9.5, xend=9.5, y=9.5, yend=6.5)),
    geom_segment(aes(x=9.5, xend=9.5, y=5.5, yend=2.5)),
    geom_segment(aes(x=2.5, xend=9.5, y=2.5, yend=2.5)),
    geom_segment(aes(x=2.5, xend=2.5, y=2.5, yend=6.5)),
    geom_segment(aes(x=2.5, xend=2.5, y=7.5, yend=9.5)),
    geom_segment(aes(x=2.5, xend=7.5, y=9.5, yend=9.5)),
    geom_segment(aes(x=8.5, xend=9.5, y=9.5, yend=9.5))
  ),
  # PX_PX_0
  c(
    geom_segment(aes(x=2.5, xend=6.5, y=2.5, yend=2.5)),
    geom_segment(aes(x=7.5, xend=9.5, y=2.5, yend=2.5)),
    geom_segment(aes(x=9.5, xend=9.5, y=2.5, yend=9.5)),
    geom_segment(aes(x=2.5, xend=6.5, y=9.5, yend=9.5)),
    geom_segment(aes(x=7.5, xend=9.5, y=9.5, yend=9.5)),
    geom_segment(aes(x=2.5, xend=2.5, y=2.5, yend=3.5)),
    geom_segment(aes(x=2.5, xend=2.5, y=4.5, yend=9.5))
  ),
  # PX_UN_0
  c(
    geom_segment(aes(x=2.5, xend=9.5, y=2.5, yend=2.5)),
    geom_segment(aes(x=9.5, xend=9.5, y=2.5, yend=4.5)),
    geom_segment(aes(x=9.5, xend=9.5, y=5.5, yend=8.5)),
    geom_segment(aes(x=2.5, xend=9.5, y=9.5, yend=9.5)),
    geom_segment(aes(x=2.5, xend=2.5, y=2.5, yend=5.5)),
    geom_segment(aes(x=2.5, xend=2.5, y=6.5, yend=9.5))
  ),
  # UN_DX_0
  c(
    geom_segment(aes(x=9.5, xend=9.5, y=9.5, yend=2.5)),
    geom_segment(aes(x=2.5, xend=5.5, y=2.5, yend=2.5)),
    geom_segment(aes(x=6.5, xend=9.5, y=2.5, yend=2.5)),
    geom_segment(aes(x=2.5, xend=2.5, y=2.5, yend=5.5)),
    geom_segment(aes(x=2.5, xend=2.5, y=6.5, yend=9.5)),
    geom_segment(aes(x=2.5, xend=9.5, y=9.5, yend=9.5))
  ),
  # UN_NX_0
  c(
    geom_segment(aes(x=2.5, xend=7.5, y=2.5, yend=2.5)),
    geom_segment(aes(x=8.5, xend=9.5, y=2.5, yend=2.5)),
    geom_segment(aes(x=9.5, xend=9.5, y=2.5, yend=9.5)),
    geom_segment(aes(x=2.5, xend=9.5, y=9.5, yend=9.5)),
    geom_segment(aes(x=2.5, xend=2.5, y=2.5, yend=7.5)),
    geom_segment(aes(x=2.5, xend=2.5, y=8.5, yend=9.5))

  ),
  # UN_PX_0
  c(
    geom_segment(aes(x=9.5, xend=9.5, y=9.5, yend=7.5)),
    geom_segment(aes(x=9.5, xend=9.5, y=6.5, yend=2.5)),
    geom_segment(aes(x=2.5, xend=9.5, y=2.5, yend=2.5)),
    geom_segment(aes(x=2.5, xend=2.5, y=2.5, yend=9.5)),
    geom_segment(aes(x=2.5, xend=6.5, y=9.5, yend=9.5)),
    geom_segment(aes(x=7.5, xend=9.5, y=9.5, yend=9.5))
  ),
  # UN_UN_0
  c(
    geom_segment(aes(x=9.5, xend=9.5, y=9.5, yend=6.5)),
    geom_segment(aes(x=9.5, xend=9.5, y=5.5, yend=2.5)),
    geom_segment(aes(x=2.5, xend=9.5, y=2.5, yend=2.5)),
    geom_segment(aes(x=2.5, xend=2.5, y=2.5, yend=9.5)),
    geom_segment(aes(x=2.5, xend=5.5, y=9.5, yend=9.5)),
    geom_segment(aes(x=6.5, xend=9.5, y=9.5, yend=9.5))
  )
)

walls = list(
  # DX_DX_0
  c(),
  # DX_NX_0
  c(
    geom_rect(aes(xmin=3.5, xmax=4.5, ymin=2.5, ymax=3.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=3.5, xmax=4.5, ymin=3.5, ymax=4.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=3.5, xmax=4.5, ymin=4.5, ymax=5.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=3.5, xmax=4.5, ymin=5.5, ymax=6.5, fill="gray"), alpha=1)
  ),
  # DX_PX_0
  c(
    geom_rect(aes(xmin=3.5, xmax=4.5, ymin=6.5, ymax=7.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=4.5, xmax=5.5, ymin=6.5, ymax=7.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=5.5, xmax=6.5, ymin=6.5, ymax=7.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=7.5, xmax=8.5, ymin=5.5, ymax=6.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=7.5, xmax=8.5, ymin=6.5, ymax=7.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=8.5, xmax=9.5, ymin=6.5, ymax=7.5, fill="gray"), alpha=1)
  ),
  # DX_UN_0
  c(
    geom_rect(aes(xmin=4.5, xmax=5.5, ymin=4.5, ymax=5.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=6.5, xmax=7.5, ymin=4.5, ymax=5.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=7.5, xmax=8.5, ymin=4.5, ymax=5.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=8.5, xmax=9.5, ymin=4.5, ymax=5.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=4.5, xmax=5.5, ymin=6.5, ymax=7.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=4.5, xmax=5.5, ymin=7.5, ymax=8.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=4.5, xmax=5.5, ymin=8.5, ymax=9.5, fill="gray"), alpha=1)
  ),
  # ND_DX_0
  c(),
  # ND_DX_1
  c(),
  # ND_NX_0
  c(),
  # ND_NX_1
  c(),
  # ND_PX_0
  c(),
  # ND_PX_1
  c(
    geom_rect(aes(xmin=5.5, xmax=6.5, ymin=3.5, ymax=4.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=6.5, xmax=7.5, ymin=3.5, ymax=4.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=7.5, xmax=8.5, ymin=3.5, ymax=4.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=8.5, xmax=9.5, ymin=3.5, ymax=4.5, fill="gray"), alpha=1)
  ),
  # ND_UN_0
  c(
    geom_rect(aes(xmin=6.5, xmax=7.5, ymin=6.5, ymax=7.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=7.5, xmax=8.5, ymin=6.5, ymax=7.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=8.5, xmax=9.5, ymin=6.5, ymax=7.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=5.5, xmax=6.5, ymin=8.5, ymax=9.5, fill="gray"), alpha=1)
  ),
  # NX_DX_0
  c(
    geom_rect(aes(xmin=4.5, xmax=5.5, ymin=8.5, ymax=9.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=5.5, xmax=6.5, ymin=8.5, ymax=9.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=6.5, xmax=7.5, ymin=8.5, ymax=9.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=6.5, xmax=7.5, ymin=7.5, ymax=8.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=6.5, xmax=7.5, ymin=6.5, ymax=7.5, fill="gray"), alpha=1)
  ),
  # NX_NX_0
  c(),
  # NX_PX_0
  c(
    geom_rect(aes(xmin=5.5, xmax=6.5, ymin=4.5, ymax=5.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=6.5, xmax=7.5, ymin=4.5, ymax=5.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=7.5, xmax=8.5, ymin=4.5, ymax=5.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=4.5, xmax=5.5, ymin=6.5, ymax=7.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=4.5, xmax=5.5, ymin=7.5, ymax=8.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=4.5, xmax=5.5, ymin=8.5, ymax=9.5, fill="gray"), alpha=1)
  ),
  # NX_UN_0
  c(
    geom_rect(aes(xmin=8.5, xmax=9.5, ymin=3.5, ymax=4.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=6.5, xmax=7.5, ymin=4.5, ymax=5.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=6.5, xmax=7.5, ymin=5.5, ymax=6.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=6.5, xmax=7.5, ymin=6.5, ymax=7.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=6.5, xmax=7.5, ymin=7.5, ymax=8.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=5.5, xmax=6.5, ymin=7.5, ymax=8.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=4.5, xmax=5.5, ymin=7.5, ymax=8.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=3.5, xmax=4.5, ymin=7.5, ymax=8.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=3.5, xmax=4.5, ymin=8.5, ymax=9.5, fill="gray"), alpha=1)
  ),
  # PX_DX_0
  c(
    geom_rect(aes(xmin=3.5, xmax=4.5, ymin=5.5, ymax=6.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=3.5, xmax=4.5, ymin=6.5, ymax=7.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=5.5, xmax=6.5, ymin=8.5, ymax=9.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=5.5, xmax=6.5, ymin=7.5, ymax=8.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=6.5, xmax=7.5, ymin=7.5, ymax=8.5, fill="gray"), alpha=1)
  ),
  # PX_NX_0
  c(
    geom_rect(aes(xmin=2.5, xmax=3.5, ymin=3.5, ymax=4.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=3.5, xmax=4.5, ymin=3.5, ymax=4.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=4.5, xmax=5.5, ymin=3.5, ymax=4.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=6.5, xmax=7.5, ymin=3.5, ymax=4.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=7.5, xmax=8.5, ymin=3.5, ymax=4.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=8.5, xmax=9.5, ymin=3.5, ymax=4.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=6.5, xmax=7.5, ymin=5.5, ymax=6.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=6.5, xmax=7.5, ymin=6.5, ymax=7.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=6.5, xmax=7.5, ymin=7.5, ymax=8.5, fill="gray"), alpha=1)
  ),
  # PX_PX_0
  c(
    geom_rect(aes(xmin=5.5, xmax=6.5, ymin=5.5, ymax=6.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=5.5, xmax=6.5, ymin=6.5, ymax=7.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=5.5, xmax=6.5, ymin=7.5, ymax=8.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=5.5, xmax=6.5, ymin=8.5, ymax=9.5, fill="gray"), alpha=1)
  ),
  # PX_UN_0
  c(
    geom_rect(aes(xmin=3.5, xmax=4.5, ymin=7.5, ymax=8.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=3.5, xmax=4.5, ymin=8.5, ymax=9.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=8.5, xmax=9.5, ymin=3.5, ymax=4.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=7.5, xmax=8.5, ymin=3.5, ymax=4.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=7.5, xmax=8.5, ymin=4.5, ymax=5.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=7.5, xmax=8.5, ymin=5.5, ymax=6.5, fill="gray"), alpha=1)
  ),
  # UN_DX_0
  c(
    geom_rect(aes(xmin=2.5, xmax=3.5, ymin=6.5, ymax=7.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=3.5, xmax=4.5, ymin=6.5, ymax=7.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=4.5, xmax=5.5, ymin=6.5, ymax=7.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=6.5, xmax=7.5, ymin=3.5, ymax=4.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=6.5, xmax=7.5, ymin=4.5, ymax=5.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=7.5, xmax=8.5, ymin=4.5, ymax=5.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=8.5, xmax=9.5, ymin=4.5, ymax=5.5, fill="gray"), alpha=1)
  ),
  # UN_NX_0
  c(
    geom_rect(aes(xmin=4.5, xmax=5.5, ymin=4.5, ymax=5.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=4.5, xmax=5.5, ymin=5.5, ymax=6.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=4.5, xmax=5.5, ymin=6.5, ymax=7.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=5.5, xmax=6.5, ymin=4.5, ymax=5.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=5.5, xmax=6.5, ymin=5.5, ymax=6.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=5.5, xmax=6.5, ymin=6.5, ymax=7.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=6.5, xmax=7.5, ymin=4.5, ymax=5.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=6.5, xmax=7.5, ymin=5.5, ymax=6.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=6.5, xmax=7.5, ymin=6.5, ymax=7.5, fill="gray"), alpha=1)
  ),
  # UN_PX_0
  c(
    geom_rect(aes(xmin=4.5, xmax=5.5, ymin=4.5, ymax=5.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=5.5, xmax=6.5, ymin=4.5, ymax=5.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=5.5, xmax=6.5, ymin=3.5, ymax=4.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=5.5, xmax=6.5, ymin=2.5, ymax=3.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=7.5, xmax=8.5, ymin=4.5, ymax=5.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=8.5, xmax=9.5, ymin=4.5, ymax=5.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=5.5, xmax=6.5, ymin=8.5, ymax=9.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=5.5, xmax=6.5, ymin=7.5, ymax=8.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=5.5, xmax=6.5, ymin=6.5, ymax=7.5, fill="gray"), alpha=1)
  ),
  # UN_UN_0
  c(
    geom_rect(aes(xmin=4.5, xmax=5.5, ymin=4.5, ymax=5.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=6.5, xmax=7.5, ymin=4.5, ymax=5.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=7.5, xmax=8.5, ymin=4.5, ymax=5.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=8.5, xmax=9.5, ymin=4.5, ymax=5.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=4.5, xmax=5.5, ymin=6.5, ymax=7.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=4.5, xmax=5.5, ymin=7.5, ymax=8.5, fill="gray"), alpha=1),
    geom_rect(aes(xmin=4.5, xmax=5.5, ymin=8.5, ymax=9.5, fill="gray"), alpha=1)
  )
)
