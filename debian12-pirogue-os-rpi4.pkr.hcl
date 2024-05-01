packer {
  required_plugins {
    arm-image = {
      version = ">= 0.2.5"
      source  = "github.com/solo-io/arm-image"
    }
  }
}


source "arm-image" "pirogue-os" {
  iso_checksum = "file:https://raspi.debian.net/tested/20231109_raspi_4_bookworm.img.xz.sha256"
  iso_url      = "https://raspi.debian.net/tested/20231109_raspi_4_bookworm.img.xz"
  image_type   = "raspberrypi"
}

build {
  source "source.arm-image.pirogue-os" {
    name = "PiRogue-OS-12-Pi3_and_Pi4"
  }

  provisioner "shell" {
    script = "./debian-12/script.sh"
  }

  post-processor "compress" {
    output = "${source.name}-${formatdate("YYYY-MM-DD", timestamp())}.xz"
  }


  post-processor "checksum" {
    checksum_types = ["sha256"]
    output         = "${source.name}-${formatdate("YYYY-MM-DD", timestamp())}.xz.{{.ChecksumType}}"
  }

}
