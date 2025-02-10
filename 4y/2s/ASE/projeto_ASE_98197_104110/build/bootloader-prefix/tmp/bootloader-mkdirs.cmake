# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

cmake_minimum_required(VERSION 3.5)

file(MAKE_DIRECTORY
  "C:/Espressif/frameworks/esp-idf-v5.2/components/bootloader/subproject"
  "C:/Users/tiago/OneDrive/Documentos/4ano2sem/ASE/ASE/projeto_ASE_98197_104110/build/bootloader"
  "C:/Users/tiago/OneDrive/Documentos/4ano2sem/ASE/ASE/projeto_ASE_98197_104110/build/bootloader-prefix"
  "C:/Users/tiago/OneDrive/Documentos/4ano2sem/ASE/ASE/projeto_ASE_98197_104110/build/bootloader-prefix/tmp"
  "C:/Users/tiago/OneDrive/Documentos/4ano2sem/ASE/ASE/projeto_ASE_98197_104110/build/bootloader-prefix/src/bootloader-stamp"
  "C:/Users/tiago/OneDrive/Documentos/4ano2sem/ASE/ASE/projeto_ASE_98197_104110/build/bootloader-prefix/src"
  "C:/Users/tiago/OneDrive/Documentos/4ano2sem/ASE/ASE/projeto_ASE_98197_104110/build/bootloader-prefix/src/bootloader-stamp"
)

set(configSubDirs )
foreach(subDir IN LISTS configSubDirs)
    file(MAKE_DIRECTORY "C:/Users/tiago/OneDrive/Documentos/4ano2sem/ASE/ASE/projeto_ASE_98197_104110/build/bootloader-prefix/src/bootloader-stamp/${subDir}")
endforeach()
if(cfgdir)
  file(MAKE_DIRECTORY "C:/Users/tiago/OneDrive/Documentos/4ano2sem/ASE/ASE/projeto_ASE_98197_104110/build/bootloader-prefix/src/bootloader-stamp${cfgdir}") # cfgdir has leading slash
endif()
