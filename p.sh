#!/bin/bash

# Copyright 2024 Purrr
# Github @sandatjepil

# Ini Pengaturan buat kirim ke supergroup (grup bertopik)
# Set 1 untuk Ya | 0 untuk Tidak
TG_SUPER=0

# Isi token BOT disini
TG_TOKEN=6518927200:AAHjFrqksWKWA-bykHW5d_8kx6p0tSb8M_s

# isi ID channel atau grup
# Pastikan botnya sudah jadi admin
CHATID=-1002019685512
# kalo grupnya bertopic isi ini, kalo ngga kosongin aja
TOPICID=

#################################################
# BAGIAN INI JANGAN DISENTUH!!
#################################################
BOT_MSG_URL="https://api.telegram.org/bot$TG_TOKEN/sendMessage"
BOT_BUILD_URL="https://api.telegram.org/bot$TG_TOKEN/sendDocument"

tg_post_msg(){
	if [ $TG_SUPER = 1 ]
	then
	    curl -s -X POST "$BOT_MSG_URL" \
	    -d chat_id="$CHATID" \
	    -d message_thread_id="$TOPICID" \
	    -d "disable_web_page_preview=true" \
	    -d "parse_mode=html" \
	    -d text="$1"
	else
	    curl -s -X POST "$BOT_MSG_URL" \
	    -d chat_id="$CHATID" \
	    -d "disable_web_page_preview=true" \
	    -d "parse_mode=html" \
	    -d text="$1"
	fi
}

tg_post_build()
{
	#Post MD5Checksum alongwith for easeness
	MD5CHECK=$(md5sum "$1" | cut -d' ' -f1)

	#Show the Checksum alongwith caption
	if [ $TG_SUPER = 1 ]
	then
	    curl --no-progress-meter -F document=@"$1" "$BOT_BUILD_URL" \
	    -F chat_id="$CHATID"  \
	    -F message_thread_id="$TOPICID" \
	    -F "disable_web_page_preview=true" \
	    -F "parse_mode=Markdown" \
	    -F caption="$2
*MD5 Checksum:* \`$MD5CHECK\`"
	else
	    curl --no-progress-meter -F document=@"$1" "$BOT_BUILD_URL" \
	    -F chat_id="$CHATID"  \
	    -F "disable_web_page_preview=true" \
	    -F "parse_mode=Markdown" \
	    -F caption="$2
*MD5 Checksum:* \`$MD5CHECK\`"
	fi
}

case "$1" in
  file)
    PESAN=$(tg_post_build "$2" "$3" | grep '"ok":')
    if (echo ${PESAN} | grep '"ok":true' > /dev/null 2>&1); then
    echo "berhasil kirim file ke ID ${CHATID}"
    else
    echo "gagal kirim file ke ID ${CHATID}"
    echo "Alasan: ${PESAN}"
    fi
    ;;
  msg)
    PESAN=$(tg_post_msg "$2" | grep '"ok":')
    if (echo ${PESAN} | grep '"ok":true' > /dev/null 2>&1); then
    echo "Berhasil kirim pesan ke ID ${CHATID}"
    else
    echo "Gagal kirim pesan ke ID ${CHATID}"
    echo "Alasan: ${PESAN}"
    fi
    ;;
  help)
    echo "Cara Pemakaian:"
    echo ""
    echo "- Untuk kirim file"
    echo 'kirimtele.sh file "nama-file" "caption"'
    echo "- Untuk kirim pesan"
    echo 'kirimtele.sh msg "caption"'
    ;;
  *)
    echo "command tidak ditemukan"
    echo "ketik kirimtele.sh help"
    echo "untuk cara penggunaan"
    ;;
esac
#################################################
# BAGIAN INI JANGAN DISENTUH!!
#################################################
