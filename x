[33mcommit c22009ad76c9aaa2b601db8353f949d6f3c8835e[m
Merge: 42df8dd2dc84 a8bf86a0e0fa
Author: Michael Bestas <mkbestas@lineageos.org>
Date:   Fri Jan 10 13:09:21 2025 +0200

    Merge tag 'ASB-2025-01-05_4.19-stable' of https://android.googlesource.com/kernel/common into android13-4.19-kona
    
    https://source.android.com/docs/security/bulletin/2025-01-01
    
    * tag 'ASB-2025-01-05_4.19-stable' of https://android.googlesource.com/kernel/common: (132 commits)
      Revert "UPSTREAM: unicode: Don't special case ignorable code points"
      Reapply "UPSTREAM: unicode: Don't special case ignorable code points"
      Revert "UPSTREAM: unicode: Don't special case ignorable code points"
      Linux 4.19.325
      sh: intc: Fix use-after-free bug in register_intc_controller()
      modpost: remove incorrect code in do_eisa_entry()
      9p/xen: fix release of IRQ
      9p/xen: fix init sequence
      block: return unsigned int from bdev_io_min
      jffs2: fix use of uninitialized variable
      ubi: fastmap: Fix duplicate slab cache names while attaching
      ubifs: Correct the total block count by deducting journal reservation
      rtc: check if __rtc_read_time was successful in rtc_timer_do_work()
      NFSv4.0: Fix a use-after-free problem in the asynchronous open()
      um: Fix the return value of elf_core_copy_task_fpregs
      rpmsg: glink: Propagate TX failures in intentless mode as well
      NFSD: Prevent a potential integer overflow
      lib: string_helpers: silence snprintf() output truncation warning
      usb: dwc3: gadget: Fix checking for number of TRBs left
      media: wl128x: Fix atomicity violation in fmc_send_cmd()
      ...
    
     Conflicts:
            arch/arm64/boot/dts/vendor/bindings/clock/adi,axi-clkgen.yaml
            arch/arm64/boot/dts/vendor/bindings/clock/axi-clkgen.txt
            drivers/rpmsg/qcom_glink_native.c
    
    Change-Id: Iea6ddf20dfaa4419f6e0b2efcee1890bfa8e2554

[1mdiff --cc arch/arm64/boot/dts/vendor/bindings/clock/adi,axi-clkgen.yaml[m
[1mindex 000000000000,bb2eec3021a0..bb2eec3021a0[m
mode 000000,100644..100644[m
[1m--- a/arch/arm64/boot/dts/vendor/bindings/clock/adi,axi-clkgen.yaml[m
[1m+++ b/arch/arm64/boot/dts/vendor/bindings/clock/adi,axi-clkgen.yaml[m
[1mdiff --cc drivers/rpmsg/qcom_glink_native.c[m
[1mindex dd04cb48d025,17c342b4fe72..dcde0a2a6a78[m
[1m--- a/drivers/rpmsg/qcom_glink_native.c[m
[1m+++ b/drivers/rpmsg/qcom_glink_native.c[m
[36m@@@ -246,21 -191,20 +246,21 @@@[m [mstruct glink_channel [m
  [m
  static const struct rpmsg_endpoint_ops glink_endpoint_ops;[m
  [m
[31m- #define RPM_CMD_VERSION			0[m
[31m- #define RPM_CMD_VERSION_ACK		1[m
[31m- #define RPM_CMD_OPEN			2[m
[31m- #define RPM_CMD_CLOSE			3[m
[31m- #define RPM_CMD_OPEN_ACK		4[m
[31m- #define RPM_CMD_INTENT			5[m
[31m- #define RPM_CMD_RX_DONE			6[m
[31m- #define RPM_CMD_RX_INTENT_REQ		7[m
[31m- #define RPM_CMD_RX_INTENT_REQ_ACK	8[m
[31m- #define RPM_CMD_TX_DATA			9[m
[31m- #define RPM_CMD_CLOSE_ACK		11[m
[31m- #define RPM_CMD_TX_DATA_CONT		12[m
[31m- #define RPM_CMD_READ_NOTIF		13[m
[31m- #define RPM_CMD_RX_DONE_W_REUSE		14[m
[31m- #define RPM_CMD_SIGNALS			15[m
[32m+ #define GLINK_CMD_VERSION		0[m
[32m+ #define GLINK_CMD_VERSION_ACK		1[m
[32m+ #define GLINK_CMD_OPEN			2[m
[32m+ #define GLINK_CMD_CLOSE			3[m
[32m+ #define GLINK_CMD_OPEN_ACK		4[m
[32m+ #define GLINK_CMD_INTENT		5[m
[32m+ #define GLINK_CMD_RX_DONE		6[m
[32m+ #define GLINK_CMD_RX_INTENT_REQ		7[m
[32m+ #define GLINK_CMD_RX_INTENT_REQ_ACK	8[m
[32m+ #define GLINK_CMD_TX_DATA		9[m
[32m+ #define GLINK_CMD_CLOSE_ACK		11[m
[32m+ #define GLINK_CMD_TX_DATA_CONT		12[m
[32m+ #define GLINK_CMD_READ_NOTIF		13[m
[32m+ #define GLINK_CMD_RX_DONE_W_REUSE	14[m
[32m++#define GLINK_CMD_SIGNALS		15[m
  [m
  #define GLINK_FEATURE_INTENTLESS	BIT(1)[m
  [m
[36m@@@ -571,12 -456,11 +571,12 @@@[m [mstatic int qcom_glink_send_open_req(str[m
  		return ret;[m
  [m
  	channel->lcid = ret;[m
[32m +	CH_INFO(channel, "\n");[m
  [m
[31m- 	req.msg.cmd = cpu_to_le16(RPM_CMD_OPEN);[m
[32m+ 	req.msg.cmd = cpu_to_le16(GLINK_CMD_OPEN);[m
  	req.msg.param1 = cpu_to_le16(channel->lcid);[m
  	req.msg.param2 = cpu_to_le32(name_len);[m
[31m -	strcpy(req.name, channel->name);[m
[32m +	strlcpy(req.name, channel->name, GLINK_NAME_SIZE);[m
  [m
  	ret = qcom_glink_tx(glink, &req, req_len, NULL, 0, true);[m
  	if (ret)[m
[36m@@@ -632,34 -512,10 +632,34 @@@[m [mstatic int __qcom_glink_rx_done(struct [m
  		u16 lcid;[m
  		u32 liid;[m
  	} __packed cmd;[m
[31m -[m
  	unsigned int cid = channel->lcid;[m
[31m -	unsigned int iid;[m
[31m -	bool reuse;[m
[32m +	unsigned int iid = intent->id;[m
[32m +	bool reuse = intent->reuse;[m
[32m +	int ret;[m
[32m +[m
[31m- 	cmd.id = reuse ? RPM_CMD_RX_DONE_W_REUSE : RPM_CMD_RX_DONE;[m
[32m++	cmd.id = reuse ? GLINK_CMD_RX_DONE_W_REUSE : GLINK_CMD_RX_DONE;[m
[32m +	cmd.lcid = cid;[m
[32m +	cmd.liid = iid;[m
[32m +[m
[32m +	ret = qcom_glink_tx(glink, &cmd, sizeof(cmd), NULL, 0, wait);[m
[32m +	if (ret)[m
[32m +		return ret;[m
[32m +[m
[32m +	if (!reuse) {[m
[32m +		kfree(intent->data);[m
[32m +		kfree(intent);[m
[32m +	}[m
[32m +[m
[32m +	CH_INFO(channel, "reuse:%d liid:%d", reuse, iid);[m
[32m +	return 0;[m
[32m +}[m
[32m +[m
[32m +static void qcom_glink_rx_done_work(struct kthread_work *work)[m
[32m +{[m
[32m +	struct glink_channel *channel = container_of(work, struct glink_channel,[m
[32m +						     intent_work);[m
[32m +	struct qcom_glink *glink = channel->glink;[m
[32m +	struct glink_core_rx_intent *intent, *tmp;[m
  	unsigned long flags;[m
  [m
  	spin_lock_irqsave(&channel->intent_lock, flags);[m
[36m@@@ -813,17 -667,8 +813,17 @@@[m [mstatic int qcom_glink_advertise_intent([m
  		__le32 liid;[m
  	} __packed;[m
  	struct command cmd;[m
[32m +	unsigned long flags;[m
[32m +[m
[32m +	spin_lock_irqsave(&channel->intent_lock, flags);[m
[32m +	if (intent->advertised) {[m
[32m +		spin_unlock_irqrestore(&channel->intent_lock, flags);[m
[32m +		return 0;[m
[32m +	}[m
[32m +	intent->advertised = true;[m
[32m +	spin_unlock_irqrestore(&channel->intent_lock, flags);[m
  [m
[31m- 	cmd.id = cpu_to_le16(RPM_CMD_INTENT);[m
[32m+ 	cmd.id = cpu_to_le16(GLINK_CMD_INTENT);[m
  	cmd.lcid = cpu_to_le16(channel->lcid);[m
  	cmd.count = cpu_to_le32(1);[m
  	cmd.size = cpu_to_le32(intent->size);[m
[36m@@@ -1200,55 -1003,8 +1200,55 @@@[m [mstatic int qcom_glink_rx_open_ack(struc[m
  		return -EINVAL;[m
  	}[m
  [m
[32m +	CH_INFO(channel, "\n");[m
  	complete_all(&channel->open_ack);[m
[32m +	qcom_glink_channel_ref_put(channel);[m
[32m +	return 0;[m
[32m +}[m
[32m +[m
[32m +/**[m
[32m + * qcom_glink_send_signals() - convert a signal  cmd to wire format and transmit[m
[32m + * @glink:	The transport to transmit on.[m
[32m + * @channel:	The glink channel[m
[32m + * @sigs:	The signals to encode.[m
[32m + *[m
[32m + * Return: 0 on success or standard Linux error code.[m
[32m + */[m
[32m +static int qcom_glink_send_signals(struct qcom_glink *glink,[m
[32m +				   struct glink_channel *channel,[m
[32m +				   u32 sigs)[m
[32m +{[m
[32m +	struct glink_msg msg;[m
[32m +[m
[31m- 	msg.cmd = cpu_to_le16(RPM_CMD_SIGNALS);[m
[32m++	msg.cmd = cpu_to_le16(GLINK_CMD_SIGNALS);[m
[32m +	msg.param1 = cpu_to_le16(channel->lcid);[m
[32m +	msg.param2 = cpu_to_le32(sigs);[m
[32m +[m
[32m +	GLINK_INFO(glink->ilc, "sigs:%d\n", sigs);[m
[32m +	return qcom_glink_tx(glink, &msg, sizeof(msg), NULL, 0, true);[m
[32m +}[m
[32m +[m
[32m +static int qcom_glink_handle_signals(struct qcom_glink *glink,[m
[32m +				     unsigned int rcid, unsigned int signals)[m
[32m +{[m
[32m +	struct glink_channel *channel;[m
[32m +	u32 old;[m
[32m +[m
[32m +	channel = qcom_glink_channel_ref_get(glink, true, rcid);[m
[32m +	if (!channel) {[m
[32m +		dev_err(glink->dev, "signal for non-existing channel\n");[m
[32m +		return -EINVAL;[m
[32m +	}[m
[32m +[m
[32m +	old = channel->rsigs;[m
[32m +	channel->rsigs = signals;[m
  [m
[32m +	if (channel->ept.sig_cb)[m
[32m +		channel->ept.sig_cb(channel->ept.rpdev, old, channel->rsigs);[m
[32m +[m
[32m +	CH_INFO(channel, "old:%d new:%d\n", old, channel->rsigs);[m
[32m +[m
[32m +	qcom_glink_channel_ref_put(channel);[m
  	return 0;[m
  }[m
  [m
[36m@@@ -1316,10 -1073,6 +1317,10 @@@[m [mstatic irqreturn_t qcom_glink_native_in[m
  			qcom_glink_handle_intent_req_ack(glink, param1, param2);[m
  			qcom_glink_rx_advance(glink, ALIGN(sizeof(msg), 8));[m
  			break;[m
[31m- 		case RPM_CMD_SIGNALS:[m
[32m++		case GLINK_CMD_SIGNALS:[m
[32m +			qcom_glink_handle_signals(glink, param1, param2);[m
[32m +			qcom_glink_rx_advance(glink, ALIGN(sizeof(msg), 8));[m
[32m +			break;[m
  		default:[m
  			dev_err(glink->dev, "unhandled rx cmd: %d\n", cmd);[m
  			ret = -EINVAL;[m
[36m@@@ -1546,9 -1270,9 +1547,9 @@@[m [mstatic int qcom_glink_request_intent(st[m
  [m
  	mutex_lock(&channel->intent_req_lock);[m
  [m
[31m -	reinit_completion(&channel->intent_req_comp);[m
[32m +	atomic_set(&channel->intent_req_comp, 0);[m
  [m
[31m- 	cmd.id = RPM_CMD_RX_INTENT_REQ;[m
[32m+ 	cmd.id = GLINK_CMD_RX_INTENT_REQ;[m
  	cmd.cid = channel->lcid;[m
  	cmd.size = size;[m
  [m
