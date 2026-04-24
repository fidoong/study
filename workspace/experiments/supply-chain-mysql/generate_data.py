
#!/usr/bin/env python3
import json, random
from datetime import datetime, timedelta
from itertools import count

OUTPUT = "/Users/fidoo/Desktop/study/workspace/experiments/supply-chain-mysql/scm_data.sql"
random.seed(42)

def idg(s=1): return count(s)
def now(): return "'" + datetime.now().strftime("%Y-%m-%d %H:%M:%S") + "'"
def rd(a=-365,b=0): return "'" + (datetime.now()+timedelta(days=random.randint(a,b))).strftime("%Y-%m-%d") + "'"
def rdt(d=365):
    dt=datetime.now()-timedelta(seconds=random.randint(0,d*86400))
    return "'"+dt.strftime("%Y-%m-%d %H:%M:%S")+"'"
def rp():
    p=["138","139","136","137","135","150","151","152","158","159","186","187","188"]
    return random.choice(p)+"".join(random.choices("0123456789",k=8))
def esc(s):
    if s is None: return "NULL"
    return "'"+str(s).replace("'","\\'")+"'"

def sql(t,c,rs):
    if not rs: return ""
    v=[]
    for r in rs:
        vs=[]
        for x in r:
            if x is None: vs.append("NULL")
            elif isinstance(x,str) and not x.startswith("'"): vs.append(esc(x))
            else: vs.append(str(x))
        v.append("("+", ".join(vs)+")")
    return f"INSERT INTO {t} ({', '.join(c)}) VALUES\n" + ",\n".join(v) + ";\n\n"

R={}
oid=idg(1)
R["organization"]=[
    (next(oid),"GROUP001","环球供应链集团",1,0,1,"/1/",None,"010-88888888","group@scm.com","北京市朝阳区环球中心",0,1,now(),now(),0,0,"NULL",1,"集团总部"),
    (next(oid),"COMP001","华东分公司",2,1,2,"/1/2/",3,"021-66668888","huadong@scm.com","上海市浦东新区张江高科",1,1,now(),now(),1,1,"NULL",1,"华东区域"),
    (next(oid),"COMP002","华南分公司",2,1,2,"/1/3/",4,"020-88886666","huanan@scm.com","广州市天河区珠江新城",2,1,now(),now(),1,1,"NULL",1,"华南区域"),
    (next(oid),"COMP003","华北分公司",2,1,2,"/1/4/",5,"010-66669999","huabei@scm.com","北京市海淀区中关村",3,1,now(),now(),1,1,"NULL",1,"华北区域"),
    (next(oid),"DEPT001","采购部",3,2,3,"/1/2/5/",6,"021-66668801","purchase@scm.com","上海市浦东新区张江高科A座",1,1,now(),now(),1,1,"NULL",1,"负责采购业务"),
    (next(oid),"DEPT002","销售部",3,2,3,"/1/2/6/",7,"021-66668802","sales@scm.com","上海市浦东新区张江高科A座",2,1,now(),now(),1,1,"NULL",1,"负责销售业务"),
    (next(oid),"DEPT003","仓储部",3,2,3,"/1/2/7/",8,"021-66668803","warehouse@scm.com","上海市浦东新区张江高科B座",3,1,now(),now(),1,1,"NULL",1,"负责仓储管理"),
    (next(oid),"DEPT004","物流部",3,2,3,"/1/2/8/",9,"021-66668804","logistics@scm.com","上海市浦东新区张江高科B座",4,1,now(),now(),1,1,"NULL",1,"负责物流配送"),
    (next(oid),"DEPT005","财务部",3,2,3,"/1/2/9/",10,"021-66668805","finance@scm.com","上海市浦东新区张江高科A座",5,1,now(),now(),1,1,"NULL",1,"负责财务管理"),
    (next(oid),"WH001","上海中心仓",4,3,3,"/1/2/10/",8,"021-66668810","sh-warehouse@scm.com","上海市浦东新区物流园1号",10,1,now(),now(),1,1,"NULL",1,"华东主仓库"),
]

uid=idg(1)
R["sys_user"]=[
    (next(uid),"admin","e10adc3949ba59abbe56e057f20f883e","系统管理员","EMP0001",1,1,rp(),"admin@scm.com",None,1,1,now(),"NULL","192.168.1.100",now(),now(),0,0,"NULL",1,"超级管理员"),
    (next(uid),"zhangsan","e10adc3949ba59abbe56e057f20f883e","张三","EMP0002",2,5,rp(),"zhangsan@scm.com",None,1,1,rdt(30),"NULL","192.168.1.101",now(),now(),0,0,"NULL",1,"华东采购经理"),
    (next(uid),"lisi","e10adc3949ba59abbe56e057f20f883e","李四","EMP0003",2,6,rp(),"lisi@scm.com",None,1,1,rdt(60),"NULL","192.168.1.102",now(),now(),0,0,"NULL",1,"华东销售经理"),
    (next(uid),"wangwu","e10adc3949ba59abbe56e057f20f883e","王五","EMP0004",2,7,rp(),"wangwu@scm.com",None,1,1,rdt(45),"NULL","192.168.1.103",now(),now(),0,0,"NULL",1,"仓储主管"),
    (next(uid),"zhaoliu","e10adc3949ba59abbe56e057f20f883e","赵六","EMP0005",3,5,rp(),"zhaoliu@scm.com",None,2,1,rdt(20),"NULL","192.168.1.104",now(),now(),0,0,"NULL",1,"采购专员"),
    (next(uid),"sunqi","e10adc3949ba59abbe56e057f20f883e","孙七","EMP0006",3,6,rp(),"sunqi@scm.com",None,1,1,rdt(15),"NULL","192.168.1.105",now(),now(),0,0,"NULL",1,"销售专员"),
    (next(uid),"zhouba","e10adc3949ba59abbe56e057f20f883e","周八","EMP0007",3,7,rp(),"zhouba@scm.com",None,1,1,rdt(10),"NULL","192.168.1.106",now(),now(),0,0,"NULL",1,"仓库管理员"),
    (next(uid),"wujiu","e10adc3949ba59abbe56e057f20f883e","吴九","EMP0008",3,5,rp(),"wujiu@scm.com",None,1,1,rdt(25),"NULL","192.168.1.107",now(),now(),0,0,"NULL",1,"采购专员"),
    (next(uid),"zhengshi","e10adc3949ba59abbe56e057f20f883e","郑十","EMP0009",3,6,rp(),"zhengshi@scm.com",None,2,1,rdt(18),"NULL","192.168.1.108",now(),now(),0,0,"NULL",1,"销售专员"),
    (next(uid),"qianyi","e10adc3949ba59abbe56e057f20f883e","钱一","EMP0010",3,9,rp(),"qianyi@scm.com",None,1,1,rdt(12),"NULL","192.168.1.109",now(),now(),0,0,"NULL",1,"财务会计"),
    (next(uid),"suner","e10adc3949ba59abbe56e057f20f883e","孙二","EMP0011",3,8,rp(),"suner@scm.com",None,1,1,rdt(8),"NULL","192.168.1.110",now(),now(),0,0,"NULL",1,"物流专员"),
    (next(uid),"linna","e10adc3949ba59abbe56e057f20f883e","林娜","EMP0012",4,5,rp(),"linna@scm.com",None,2,1,rdt(5),"NULL","192.168.1.111",now(),now(),0,0,"NULL",1,"采购助理"),
    (next(uid),"huangwu","e10adc3949ba59abbe56e057f20f883e","黄五","EMP0013",4,7,rp(),"huangwu@scm.com",None,1,1,rdt(3),"NULL","192.168.1.112",now(),now(),0,0,"NULL",1,"仓库操作员"),
    (next(uid),"xuliu","e10adc3949ba59abbe56e057f20f883e","徐六","EMP0014",4,6,rp(),"xuliu@scm.com",None,1,1,rdt(7),"NULL","192.168.1.113",now(),now(),0,0,"NULL",1,"销售助理"),
    (next(uid),"malan","e10adc3949ba59abbe56e057f20f883e","马兰","EMP0015",3,9,rp(),"malan@scm.com",None,2,1,rdt(14),"NULL","192.168.1.114",now(),now(),0,0,"NULL",1,"财务主管"),
]

rid=idg(1)
R["sys_role"]=[
    (next(rid),"ROLE_ADMIN","系统管理员",1,1,1,now(),now(),0,0,"NULL",1,"全部系统权限"),
    (next(rid),"ROLE_PURCHASE_MGR","采购经理",2,3,1,now(),now(),0,0,"NULL",1,"采购审批与管理权限"),
    (next(rid),"ROLE_PURCHASE","采购专员",2,4,1,now(),now(),0,0,"NULL",1,"采购执行权限"),
    (next(rid),"ROLE_SALES_MGR","销售经理",2,3,1,now(),now(),0,0,"NULL",1,"销售审批与管理权限"),
    (next(rid),"ROLE_SALES","销售专员",2,4,1,now(),now(),0,0,"NULL",1,"销售执行权限"),
    (next(rid),"ROLE_WAREHOUSE","仓库管理员",2,3,1,now(),now(),0,0,"NULL",1,"仓储作业权限"),
    (next(rid),"ROLE_FINANCE","财务人员",2,2,1,now(),now(),0,0,"NULL",1,"财务结算权限"),
    (next(rid),"ROLE_QC","质检员",2,3,1,now(),now(),0,0,"NULL",1,"质检作业权限"),
]

R["user_role"]=[
    (1,1,1,now()),(2,2,1,now()),(3,4,1,now()),(4,6,1,now()),
    (5,3,1,now()),(6,5,1,now()),(7,6,1,now()),(8,3,1,now()),
    (9,5,1,now()),(10,7,1,now()),(11,6,1,now()),(12,3,1,now()),
    (13,6,1,now()),(14,5,1,now()),(15,7,1,now()),
]

dtid=idg(1)
R["dict_type"]=[
    (next(dtid),"订单状态","order_status","各类订单状态",1,now(),now(),0,0,"NULL",1,None),
    (next(dtid),"审批状态","approval_status","审批流程状态",1,now(),now(),0,0,"NULL",1,None),
    (next(dtid),"付款条件","payment_terms","采购付款条件",1,now(),now(),0,0,"NULL",1,None),
    (next(dtid),"仓库类型","warehouse_type","仓库分类",1,now(),now(),0,0,"NULL",1,None),
    (next(dtid),"供应商类型","supplier_type","供应商分类",1,now(),now(),0,0,"NULL",1,None),
    (next(dtid),"客户类型","customer_type","客户分类",1,now(),now(),0,0,"NULL",1,None),
    (next(dtid),"质检结论","qc_result","质检结果",1,now(),now(),0,0,"NULL",1,None),
    (next(dtid),"优先级","priority","业务优先级",1,now(),now(),0,0,"NULL",1,None),
    (next(dtid),"配送方式","delivery_type","物流配送方式",1,now(),now(),0,0,"NULL",1,None),
    (next(dtid),"承运商类型","carrier_type","承运商分类",1,now(),now(),0,0,"NULL",1,None),
]

ddid=idg(1)
R["dict_data"]=[
    (next(ddid),1,"待处理","1",1,0,1,now(),now(),0,0,"NULL",1,None),
    (next(ddid),1,"处理中","2",2,0,1,now(),now(),0,0,"NULL",1,None),
    (next(ddid),1,"已完成","3",3,0,1,now(),now(),0,0,"NULL",1,None),
    (next(ddid),1,"已取消","0",4,0,1,now(),now(),0,0,"NULL",1,None),
    (next(ddid),2,"待审批","0",1,1,1,now(),now(),0,0,"NULL",1,None),
    (next(ddid),2,"审批中","1",2,0,1,now(),now(),0,0,"NULL",1,None),
    (next(ddid),2,"已通过","2",3,0,1,now(),now(),0,0,"NULL",1,None),
    (next(ddid),2,"已拒绝","3",4,0,1,now(),now(),0,0,"NULL",1,None),
    (next(ddid),3,"预付","1",1,1,1,now(),now(),0,0,"NULL",1,None),
    (next(ddid),3,"货到付款","2",2,0,1,now(),now(),0,0,"NULL",1,None),
    (next(ddid),3,"月结","3",3,0,1,now(),now(),0,0,"NULL",1,None),
    (next(ddid),3,"账期","4",4,0,1,now(),now(),0,0,"NULL",1,None),
    (next(ddid),4,"中心仓","1",1,1,1,now(),now(),0,0,"NULL",1,None),
    (next(ddid),4,"区域仓","2",2,0,1,now(),now(),0,0,"NULL",1,None),
    (next(ddid),4,"前置仓","3",3,0,1,now(),now(),0,0,"NULL",1,None),
    (next(ddid),4,"保税仓","4",4,0,1,now(),now(),0,0,"NULL",1,None),
    (next(ddid),4,"退货仓","5",5,0,1,now(),now(),0,0,"NULL",1,None),
    (next(ddid),5,"制造商","1",1,1,1,now(),now(),0,0,"NULL",1,None),
    (next(ddid),5,"经销商","2",2,0,1,now(),now(),0,0,"NULL",1,None),
    (next(ddid),5,"代理商","3",3,0,1,now(),now(),0,0,"NULL",1,None),
    (next(ddid),5,"物流商","4",4,0,1,now(),now(),0,0,"NULL",1,None),
    (next(ddid),6,"企业","1",1,1,1,now(),now(),0,0,"NULL",1,None),
    (next(ddid),6,"个人","2",2,0,1,now(),now(),0,0,"NULL",1,None),
    (next(ddid),6,"经销商","3",3,0,1,now(),now(),0,0,"NULL",1,None),
    (next(ddid),6,"电商","4",4,0,1,now(),now(),0,0,"NULL",1,None),
    (next(ddid),7,"待质检","0",1,1,1,now(),now(),0,0,"NULL",1,None),
    (next(ddid),7,"全部合格","1",2,0,1,now(),now(),0,0,"NULL",1,None),
    (next(ddid),7,"部分合格","2",3,0,1,now(),now(),0,0,"NULL",1,None),
    (next(ddid),7,"全部不合格","3",4,0,1,now(),now(),0,0,"NULL",1,None),
    (next(ddid),8,"紧急","1",1,0,1,now(),now(),0,0,"NULL",1,None),
    (next(ddid),8,"普通","2",2,1,1,now(),now(),0,0,"NULL",1,None),
    (next(ddid),8,"低","3",3,0,1,now(),now(),0,0,"NULL",1,None),
    (next(ddid),9,"快递","1",1,1,1,now(),now(),0,0,"NULL",1,None),
    (next(ddid),9,"物流","2",2,0,1,now(),now(),0,0,"NULL",1,None),
    (next(ddid),9,"自提","3",3,0,1,now(),now(),0,0,"NULL",1,None),
    (next(ddid),9,"专车","4",4,0,1,now(),now(),0,0,"NULL",1,None),
    (next(ddid),10,"快递","1",1,1,1,now(),now(),0,0,"NULL",1,None),
    (next(ddid),10,"物流","2",2,0,1,now(),now(),0,0,"NULL",1,None),
    (next(ddid),10,"专线","3",3,0,1,now(),now(),0,0,"NULL",1,None),
    (next(ddid),10,"冷链","4",4,0,1,now(),now(),0,0,"NULL",1,None),
    (next(ddid),10,"同城配送","5",5,0,1,now(),now(),0,0,"NULL",1,None),
]

cfgid=idg(1)
R["sys_config"]=[
    (next(cfgid),"system.name","环球供应链中台系统",1,"系统名称",1,now(),now(),0,0,"NULL",1,None),
    (next(cfgid),"system.logo","/assets/logo.png",1,"系统Logo",1,now(),now(),0,0,"NULL",1,None),
    (next(cfgid),"order.auto_approve","false",4,"订单自动审批",1,now(),now(),0,0,"NULL",1,None),
    (next(cfgid),"inventory.safety_stock_alert","true",4,"安全库存预警",1,now(),now(),0,0,"NULL",1,None),
    (next(cfgid),"finance.tax_rate_default","13",3,"默认税率(%)",1,now(),now(),0,0,"NULL",1,None),
    (next(cfgid),"wms.pick_strategy","FIFO",1,"拣货策略",1,now(),now(),0,0,"NULL",1,None),
    (next(cfgid),"notification.email_template",'{"header":"环球供应链","footer":"如有疑问请联系客服"}',2,"邮件通知模板",1,now(),now(),0,0,"NULL",1,None),
    (next(cfgid),"system.session_timeout","3600",3,"会话超时(秒)",1,now(),now(),0,0,"NULL",1,None),
]

# ============================================================
# 2. 商品中心
# ============================================================
cid=idg(1)
R["category"]=[
    (1,"CAT001","电子产品",0,1,"/1/",1,None,1,now(),now(),0,0,"NULL",1,None),
    (2,"CAT002","手机",1,2,"/1/2/",1,None,1,now(),now(),0,0,"NULL",1,None),
    (3,"CAT003","电脑",1,2,"/1/3/",2,None,1,now(),now(),0,0,"NULL",1,None),
    (4,"CAT004","配件",1,2,"/1/4/",3,None,1,now(),now(),0,0,"NULL",1,None),
    (5,"CAT005","食品饮料",0,1,"/5/",2,None,1,now(),now(),0,0,"NULL",1,None),
    (6,"CAT006","休闲食品",5,2,"/5/6/",1,None,1,now(),now(),0,0,"NULL",1,None),
    (7,"CAT007","饮料",5,2,"/5/7/",2,None,1,now(),now(),0,0,"NULL",1,None),
    (8,"CAT008","粮油调味",5,2,"/5/8/",3,None,1,now(),now(),0,0,"NULL",1,None),
    (9,"CAT009","日用百货",0,1,"/9/",3,None,1,now(),now(),0,0,"NULL",1,None),
    (10,"CAT010","洗护用品",9,2,"/9/10/",1,None,1,now(),now(),0,0,"NULL",1,None),
    (11,"CAT011","家居清洁",9,2,"/9/11/",2,None,1,now(),now(),0,0,"NULL",1,None),
    (12,"CAT012","服装鞋帽",0,1,"/12/",4,None,1,now(),now(),0,0,"NULL",1,None),
    (13,"CAT013","男装",12,2,"/12/13/",1,None,1,now(),now(),0,0,"NULL",1,None),
    (14,"CAT014","女装",12,2,"/12/14/",2,None,1,now(),now(),0,0,"NULL",1,None),
    (15,"CAT015","运动户外",12,2,"/12/15/",3,None,1,now(),now(),0,0,"NULL",1,None),
]

bid=idg(1)
R["brand"]=[
    (1,"BRD001","华为","Huawei","https://img.scm.com/brands/huawei.png","https://www.huawei.com","全球领先的ICT基础设施和智能终端提供商",1,now(),now(),0,0,"NULL",1,None),
    (2,"BRD002","苹果","Apple","https://img.scm.com/brands/apple.png","https://www.apple.com","全球知名消费电子品牌",1,now(),now(),0,0,"NULL",1,None),
    (3,"BRD003","小米","Xiaomi","https://img.scm.com/brands/xiaomi.png","https://www.mi.com","以手机智能硬件和IoT平台为核心的互联网公司",1,now(),now(),0,0,"NULL",1,None),
    (4,"BRD004","联想","Lenovo","https://img.scm.com/brands/lenovo.png","https://www.lenovo.com","全球领先ICT科技企业",1,now(),now(),0,0,"NULL",1,None),
    (5,"BRD005","三只松鼠","Three Squirrels","https://img.scm.com/brands/sanzhi.png","https://www.3songshu.com","知名互联网休闲食品品牌",1,now(),now(),0,0,"NULL",1,None),
    (6,"BRD006","可口可乐","Coca-Cola","https://img.scm.com/brands/cocacola.png","https://www.coca-cola.com","全球最大的饮料公司",1,now(),now(),0,0,"NULL",1,None),
    (7,"BRD007","宝洁","P&G","https://img.scm.com/brands/pg.png","https://www.pg.com.cn","全球日用消费品公司巨头",1,now(),now(),0,0,"NULL",1,None),
    (8,"BRD008","耐克","Nike","https://img.scm.com/brands/nike.png","https://www.nike.com","全球著名体育运动品牌",1,now(),now(),0,0,"NULL",1,None),
    (9,"BRD009","优衣库","UNIQLO","https://img.scm.com/brands/uniqlo.png","https://www.uniqlo.com","全球服饰零售知名品牌",1,now(),now(),0,0,"NULL",1,None),
    (10,"BRD010","伊利","Yili","https://img.scm.com/brands/yili.png","https://www.yili.com","中国规模最大产品线最全的乳制品企业",1,now(),now(),0,0,"NULL",1,None),
]

spuid=idg(1)
spus=[
    (1,"SPU0001","华为Mate60 Pro智能手机",2,1,"件",0.225,0.0005,"6901443256789",'["颜色","存储容量"]','华为旗舰智能手机搭载麒麟9000S芯片支持卫星通话','https://img.scm.com/spu/mate60pro.jpg','["https://img.scm.com/spu/mate60pro-1.jpg","https://img.scm.com/spu/mate60pro-2.jpg"]',1,now(),now(),0,0,"NULL",1,None),
    (2,"SPU0002","iPhone 15 Pro Max",2,2,"件",0.221,0.0004,"1901987654321",'["颜色","存储容量"]','苹果顶级旗舰手机钛金属边框A17 Pro芯片','https://img.scm.com/spu/iphone15pm.jpg','["https://img.scm.com/spu/iphone15pm-1.jpg"]',1,now(),now(),0,0,"NULL",1,None),
    (3,"SPU0003","小米14",2,3,"件",0.193,0.0004,"6912345678901",'["颜色","存储容量"]','徕卡光学镜头骁龙8 Gen3处理器','https://img.scm.com/spu/mi14.jpg','["https://img.scm.com/spu/mi14-1.jpg"]',1,now(),now(),0,0,"NULL",1,None),
    (4,"SPU0004","联想拯救者Y9000P",3,4,"件",2.550,0.0120,"6945678901234",'["配置"]','高性能游戏本第14代英特尔酷睿i9','https://img.scm.com/spu/y9000p.jpg','["https://img.scm.com/spu/y9000p-1.jpg"]',1,now(),now(),0,0,"NULL",1,None),
    (5,"SPU0005","华为FreeBuds Pro 3",4,1,"件",0.058,0.0001,"6901443256790",'["颜色"]','旗舰真无线耳机支持空间音频','https://img.scm.com/spu/fbpro3.jpg','["https://img.scm.com/spu/fbpro3-1.jpg"]',1,now(),now(),0,0,"NULL",1,None),
    (6,"SPU0006","每日坚果礼盒",6,5,"件",0.500,0.0020,"6956789012345",'["规格"]','精选全球优质坚果科学配比','https://img.scm.com/spu/jianguo.jpg','["https://img.scm.com/spu/jianguo-1.jpg"]',1,now(),now(),0,0,"NULL",1,None),
    (7,"SPU0007","可口可乐330ml*24罐",7,6,"箱",8.500,0.0250,"6951234567890",'["口味"]','经典碳酸饮料整箱装','https://img.scm.com/spu/coke.jpg','["https://img.scm.com/spu/coke-1.jpg"]',1,now(),now(),0,0,"NULL",1,None),
    (8,"SPU0008","海飞丝去屑洗发水",10,7,"件",0.450,0.0008,"6952345678901",'["容量"]','持久去屑止痒清爽控油','https://img.scm.com/spu/hfs.jpg','["https://img.scm.com/spu/hfs-1.jpg"]',1,now(),now(),0,0,"NULL",1,None),
    (9,"SPU0009","汰渍洗衣液3kg",11,7,"件",3.200,0.0040,"6953456789012",'["香型"]','深层洁净护色亮彩','https://img.scm.com/spu/tz.jpg','["https://img.scm.com/spu/tz-1.jpg"]',1,now(),now(),0,0,"NULL",1,None),
    (10,"SPU0010","耐克Air Max运动鞋",15,8,"件",0.850,0.0035,"6954567890123",'["颜色","尺码"]','经典气垫缓震舒适透气','https://img.scm.com/spu/airmax.jpg','["https://img.scm.com/spu/airmax-1.jpg"]',1,now(),now(),0,0,"NULL",1,None),
    (11,"SPU0011","优衣库HEATTECH保暖内衣",14,9,"件",0.180,0.0003,"6955678901234",'["颜色","尺码"]','吸湿发热科技轻盈保暖','https://img.scm.com/spu/heattech.jpg','["https://img.scm.com/spu/heattech-1.jpg"]',1,now(),now(),0,0,"NULL",1,None),
    (12,"SPU0012","伊利纯牛奶250ml*24盒",7,10,"箱",6.500,0.0200,"6956789012345",'["规格"]','优质乳蛋白营养早餐奶','https://img.scm.com/spu/milk.jpg','["https://img.scm.com/spu/milk-1.jpg"]',1,now(),now(),0,0,"NULL",1,None),
    (13,"SPU0013","华为MatePad Pro平板",3,1,"件",0.460,0.0010,"6901443256791",'["颜色","存储容量"]','专业生产力平板鸿蒙系统','https://img.scm.com/spu/matepad.jpg','["https://img.scm.com/spu/matepad-1.jpg"]',1,now(),now(),0,0,"NULL",1,None),
    (14,"SPU0014","苹果MacBook Pro 16",3,2,"件",2.150,0.0100,"1901987654322",'["配置"]','M3 Max芯片专业级性能','https://img.scm.com/spu/mbp16.jpg','["https://img.scm.com/spu/mbp16-1.jpg"]',1,now(),now(),0,0,"NULL",1,None),
    (15,"SPU0015","男士商务休闲衬衫",13,9,"件",0.250,0.0005,"6957890123456",'["颜色","尺码"]','免烫易打理商务通勤','https://img.scm.com/spu/shirt.jpg','["https://img.scm.com/spu/shirt-1.jpg"]',1,now(),now(),0,0,"NULL",1,None),
    (16,"SPU0016","奥利奥夹心饼干",6,5,"件",0.150,0.0003,"6958901234567",'["口味"]','经典黑白配浓郁可可香','https://img.scm.com/spu/oreo.jpg','["https://img.scm.com/spu/oreo-1.jpg"]',1,now(),now(),0,0,"NULL",1,None),
    (17,"SPU0017","农夫山泉天然水550ml*24瓶",7,10,"箱",12.500,0.0300,"6959012345678",'["规格"]','源自天然水源地弱碱性水','https://img.scm.com/spu/nfsq.jpg','["https://img.scm.com/spu/nfsq-1.jpg"]',1,now(),now(),0,0,"NULL",1,None),
    (18,"SPU0018","舒肤佳沐浴露",10,7,"件",0.520,0.0010,"6960123456789",'["香型","容量"]','温和亲肤抑菌保护','https://img.scm.com/spu/sfj.jpg','["https://img.scm.com/spu/sfj-1.jpg"]',1,now(),now(),0,0,"NULL",1,None),
    (19,"SPU0019","金龙鱼食用油5L",8,5,"件",4.800,0.0060,"6961234567890",'["种类"]','非转基因物理压榨','https://img.scm.com/spu/jly.jpg','["https://img.scm.com/spu/jly-1.jpg"]',1,now(),now(),0,0,"NULL",1,None),
    (20,"SPU0020","李宁运动跑步鞋",15,8,"件",0.720,0.0030,"6962345678901",'["颜色","尺码"]','轻量化设计缓震回弹','https://img.scm.com/spu/lining.jpg','["https://img.scm.com/spu/lining-1.jpg"]',1,now(),now(),0,0,"NULL",1,None),
]
R["product_spu"]=spus

# Generate SKUs from SPUs
skuid=idg(1)
skus=[]
prices=[]
barcodes=[]
pid=idg(1)
bid=idg(1)

# SPU spec definitions
specs_map={
    1:{"颜色":["雅川青","南糯紫","白沙银","雅丹黑"],"存储容量":["256GB","512GB","1TB"]},
    2:{"颜色":["原色钛金属","蓝色钛金属","白色钛金属","黑色钛金属"],"存储容量":["256GB","512GB","1TB"]},
    3:{"颜色":["黑色","白色","岩石青","雪山粉"],"存储容量":["256GB","512GB","1TB"]},
    4:{"配置":["i9-14900HX/32G/1T/RTX4090","i9-14900HX/16G/1T/RTX4080","i7-14700HX/16G/512G/RTX4070"]},
    5:{"颜色":["冰霜银","陶瓷白"]},
    6:{"规格":["750g礼盒装","500g家庭装","300g便携装"]},
    7:{"口味":["原味","零度","樱桃味"]},
    8:{"容量":["200ml","400ml","750ml"]},
    9:{"香型":["薰衣草","百合","清新自然"]},
    10:{"颜色":["黑白","全黑","白灰"],"尺码":["40","41","42","43","44","45"]},
    11:{"颜色":["黑色","灰色","米色"],"尺码":["M","L","XL","XXL"]},
    12:{"规格":["250ml*24盒","1L*12盒"]},
    13:{"颜色":["曜金黑","晶钻白","星河蓝"],"存储容量":["256GB","512GB"]},
    14:{"配置":["M3 Max 36G 1T","M3 Max 48G 1T","M3 Pro 18G 512G"]},
    15:{"颜色":["白色","浅蓝","浅粉"],"尺码":["38","39","40","41","42","43"]},
    16:{"口味":["原味","巧克力味","草莓味"]},
    17:{"规格":["550ml*24瓶","1.5L*12瓶","4L*4桶"]},
    18:{"香型":["纯白清香","柠檬清新","芦荟水润"],"容量":["400ml","720ml","1L"]},
    19:{"种类":["玉米油","葵花籽油","菜籽油"]},
    20:{"颜色":["黑色","白色","荧光绿"],"尺码":["40","41","42","43","44"]},
}

base_prices={
    1:6999, 2:9999, 3:3999, 4:14999, 5:1299,
    6:89, 7:58, 8:45, 9:35, 10:899,
    11:99, 12:72, 13:4999, 14:19999, 15:199,
    16:8, 17:36, 18:28, 19:68, 20:399,
}

for spu in spus:
    spu_id=spu[0]
    spu_name=spu[2]
    s=specs_map.get(spu_id,{})
    if not s:
        # single SKU
        sku_code=f"SKU{spu_id:04d}01"
        sku_name=f"{spu_name} 标准版"
        skus.append((next(skuid),sku_code,spu_id,sku_name,"{}",None,None,None,base_prices[spu_id]*0.7,base_prices[spu_id],base_prices[spu_id]*1.2,1,now(),now(),0,0,"NULL",1,None))
        prices.append((next(pid),skuid.__next__()-1,3,base_prices[spu_id],1,None,rd(-180,0),rd(180,365),1,now(),now(),0,0,"NULL",1,None))
    else:
        keys=list(s.keys())
        if len(keys)==1:
            vals=s[keys[0]]
            for i,v in enumerate(vals):
                sku_code=f"SKU{spu_id:04d}{i+1:02d}"
                sku_name=f"{spu_name} {v}"
                spec_json='{"'+keys[0]+'":"'+v+'"}'
                bp=base_prices[spu_id]+random.randint(-50,200) if spu_id<=5 else base_prices[spu_id]+random.randint(-5,20)
                skus.append((next(skuid),sku_code,spu_id,sku_name,spec_json,None,None,None,bp*0.6,bp,bp*1.15,1,now(),now(),0,0,"NULL",1,None))
                prices.append((next(pid),skuid.__next__()-1,1,bp*0.6,1,None,rd(-180,0),rd(180,365),1,now(),now(),0,0,"NULL",1,None))
                prices.append((next(pid),skuid.__next__()-1,3,bp,1,None,rd(-180,0),rd(180,365),1,now(),now(),0,0,"NULL",1,None))
                barcodes.append((next(bid),skuid.__next__()-1,f"690{random.randint(100000000,999999999)}",1,1.0,1,1,now(),now(),0,0,"NULL",1,None))
        else:
            vals1=s[keys[0]]
            vals2=s[keys[1]]
            idx=1
            for v1 in vals1:
                for v2 in vals2:
                    sku_code=f"SKU{spu_id:04d}{idx:02d}"
                    sku_name=f"{spu_name} {v1}/{v2}"
                    spec_json='{"'+keys[0]+'":"'+v1+'","'+keys[1]+'":"'+v2+'"}'
                    bp=base_prices[spu_id]+random.randint(-100,300) if spu_id<=5 else base_prices[spu_id]+random.randint(-10,30)
                    skus.append((next(skuid),sku_code,spu_id,sku_name,spec_json,None,None,None,bp*0.6,bp,bp*1.15,1,now(),now(),0,0,"NULL",1,None))
                    prices.append((next(pid),skuid.__next__()-1,1,bp*0.6,1,None,rd(-180,0),rd(180,365),1,now(),now(),0,0,"NULL",1,None))
                    prices.append((next(pid),skuid.__next__()-1,3,bp,1,None,rd(-180,0),rd(180,365),1,now(),now(),0,0,"NULL",1,None))
                    barcodes.append((next(bid),skuid.__next__()-1,f"690{random.randint(100000000,999999999)}",1,1.0,1,1,now(),now(),0,0,"NULL",1,None))
                    idx+=1

R["product_sku"]=skus
R["product_price"]=prices
R["product_barcode"]=barcodes

# ============================================================
# 3. 供应商管理
# ============================================================
supid=idg(1)
suppliers=[
    (1,"SUP0001","华为技术有限公司",1,5,1,"张经理",rp(),"supplier1@huawei.com","广东省","深圳市","龙岗区","坂田华为基地","中国工商银行深圳分行","4403010012345678","9144030019238XXXXX",10000.00,"1987-09-15","任正非","通信设备智能手机终端云计算","1",1,now(),now(),0,0,"NULL",1,"核心供应商"),
    (2,"SUP0002","富士康科技集团",1,4,1,"李总监",rp(),"supplier2@foxconn.com","广东省","深圳市","龙华区","龙华富士康科技园","中国银行深圳分行","4403010023456789","9144030019238YYYYY",50000.00,"1988-06-06","郭台铭","电子制造代工服务","1",1,now(),now(),0,0,"NULL",1,"代工合作伙伴"),
    (3,"SUP0003","京东世纪贸易有限公司",2,5,1,"王采购",rp(),"supplier3@jd.com","北京市","大兴区","亦庄","科创十一街18号","招商银行北京分行","1101010034567890","9111030277255XXXXX",50000.00,"2007-04-20","刘强东","电子商务物流配送","1",1,now(),now(),0,0,"NULL",1,"渠道供应商"),
    (4,"SUP0004","伊利实业集团股份有限公司",1,5,1,"赵经理",rp(),"supplier4@yili.com","内蒙古自治区","呼和浩特市","回民区","鄂尔多斯大街","建设银行呼和浩特分行","1501020045678901","9115000011412XXXXX",80000.00,"1993-06-04","潘刚","乳制品饮料冷饮","1",1,now(),now(),0,0,"NULL",1,"食品供应商"),
    (5,"SUP0005","宝洁中国有限公司",1,5,1,"孙总监",rp(),"supplier5@pg.com","广东省","广州市","天河区","珠江新城","汇丰银行广州分行","4401060056789012","9144010163321XXXXX",60000.00,"1988-08-18","许敏","日用消费品个人护理家居清洁","1",1,now(),now(),0,0,"NULL",1,"快消品供应商"),
    (6,"SUP0006","耐克体育中国有限公司",3,4,1,"周经理",rp(),"supplier6@nike.com","上海市","黄浦区","南京东路","中山东一路","花旗银行上海分行","3101010067890123","9131000060738XXXXX",30000.00,"1980-01-01","董炜","运动鞋服装备","1",1,now(),now(),0,0,"NULL",1,"运动品牌供应商"),
    (7,"SUP0007","优衣库中国有限公司",3,4,1,"吴采购",rp(),"supplier7@uniqlo.com","上海市","徐汇区","漕河泾","宜山路","三菱东京日联银行上海分行","3101040078901234","9131000071092XXXXX",20000.00,"2002-09-06","潘宁","休闲服装配饰","1",1,now(),now(),0,0,"NULL",1,"服装供应商"),
    (8,"SUP0008","中粮集团有限公司",2,5,1,"郑经理",rp(),"supplier8@cofco.com","北京市","朝阳区","建国门","建国门内大街8号","农业银行北京分行","1101050089012345","9111000010110XXXXX",100000.00,"1983-07-06","吕军","粮油食品地产金融","1",1,now(),now(),0,0,"NULL",1,"粮油供应商"),
    (9,"SUP0009","顺丰速运有限公司",4,5,1,"钱总监",rp(),"supplier9@sf-express.com","广东省","深圳市","福田区","新洲路","平安银行深圳分行","4403040090123456","9144030019238ZZZZZ",15000.00,"1993-03-26","王卫","快递物流供应链管理","1",1,now(),now(),0,0,"NULL",1,"物流承运商"),
    (10,"SUP0010","可口可乐中国有限公司",1,5,1,"冯经理",rp(),"supplier10@coca-cola.com","上海市","浦东新区","金桥","桂桥路","渣打银行上海分行","3101150011122233","9131000060738YYYYY",45000.00,"1927-01-01","闻锋","碳酸饮料果汁茶饮料","1",1,now(),now(),0,0,"NULL",1,"饮料供应商"),
    (11,"SUP0011","联想集团有限公司",1,4,1,"陈采购",rp(),"supplier11@lenovo.com","北京市","海淀区","中关村","联想大厦","工商银行北京分行","1101080011223344","9111000010110YYYYY",35000.00,"1984-11-09","杨元庆","个人电脑智能设备数据中心","1",1,now(),now(),0,0,"NULL",1,"IT设备供应商"),
    (12,"SUP0012","小米通讯技术有限公司",1,4,1,"褚经理",rp(),"supplier12@xiaomi.com","北京市","海淀区","清河中街","小米科技园","建设银行北京分行","1101080011334455","9111010855136XXXXX",10000.00,"2010-04-06","雷军","智能手机IoT生活消费品","1",1,now(),now(),0,0,"NULL",1,"消费电子供应商"),
    (13,"SUP0013","三只松鼠股份有限公司",1,3,1,"卫采购",rp(),"supplier13@3songshu.com","安徽省","芜湖市","弋江区","高新区","徽商银行芜湖分行","3402020011445566","9134020059142XXXXX",5000.00,"2012-02-16","章燎原","坚果干果零食","1",1,now(),now(),0,0,"NULL",1,"休闲食品供应商"),
    (14,"SUP0014","农夫山泉股份有限公司",1,5,1,"蒋经理",rp(),"supplier14@nongfu.com","浙江省","杭州市","西湖区","曙光路","招商银行杭州分行","3301060011556677","9133000014291XXXXX",8000.00,"1996-09-26","钟睒睒","包装饮用水饮料","1",1,now(),now(),0,0,"NULL",1,"饮用水供应商"),
    (15,"SUP0015","金龙鱼粮油食品股份有限公司",1,4,1,"沈采购",rp(),"supplier15@jinlongyu.com","上海市","浦东新区","陆家嘴","世纪大道","中国银行上海分行","3101150011667788","9131000013222XXXXX",20000.00,"2005-06-17","郭孔丰","食用油大米面粉","1",1,now(),now(),0,0,"NULL",1,"粮油供应商"),
]
R["supplier"]=suppliers

# Supplier contacts
scid=idg(1)
supplier_contacts=[
    (1,1,"张经理","采购总监",rp(),"zhang@huawei.com","zhang_mgr","1",1,now(),now(),0,0,"NULL",1,None),
    (2,1,"李助理","采购助理",rp(),"li@huawei.com","li_assist","0",1,now(),now(),0,0,"NULL",1,None),
    (3,2,"王总监","供应链总监",rp(),"wang@foxconn.com","wang_dir","1",1,now(),now(),0,0,"NULL",1,None),
    (4,3,"赵采购","大客户经理",rp(),"zhao@jd.com","zhao_sales","1",1,now(),now(),0,0,"NULL",1,None),
    (5,4,"孙经理","销售经理",rp(),"sun@yili.com","sun_sales","1",1,now(),now(),0,0,"NULL",1,None),
    (6,5,"周总监","渠道总监",rp(),"zhou@pg.com","zhou_ch","1",1,now(),now(),0,0,"NULL",1,None),
    (7,6,"吴经理","批发经理",rp(),"wu@nike.com","wu_wholesale","1",1,now(),now(),0,0,"NULL",1,None),
    (8,7,"郑采购","采购主管",rp(),"zheng@uniqlo.com","zheng_buyer","1",1,now(),now(),0,0,"NULL",1,None),
    (9,8,"钱经理","销售总监",rp(),"qian@cofco.com","qian_sales","1",1,now(),now(),0,0,"NULL",1,None),
    (10,9,"冯总监","商务总监",rp(),"feng@sf-express.com","feng_bd","1",1,now(),now(),0,0,"NULL",1,None),
    (11,10,"陈经理","客户经理",rp(),"chen@coca-cola.com","chen_sales","1",1,now(),now(),0,0,"NULL",1,None),
    (12,11,"褚采购","渠道经理",rp(),"chu@lenovo.com","chu_ch","1",1,now(),now(),0,0,"NULL",1,None),
    (13,12,"卫经理","销售代表",rp(),"wei@xiaomi.com","wei_rep","1",1,now(),now(),0,0,"NULL",1,None),
    (14,13,"蒋总监","电商总监",rp(),"jiang@3songshu.com","jiang_ec","1",1,now(),now(),0,0,"NULL",1,None),
    (15,14,"沈经理","KA经理",rp(),"shen@nongfu.com","shen_ka","1",1,now(),now(),0,0,"NULL",1,None),
    (16,15,"韩采购","采购经理",rp(),"han@jinlongyu.com","han_buyer","1",1,now(),now(),0,0,"NULL",1,None),
    (17,4,"杨助理","销售助理",rp(),"yang@yili.com","yang_assist","0",1,now(),now(),0,0,"NULL",1,None),
    (18,6,"朱主管","区域主管",rp(),"zhu@nike.com","zhu_reg","0",1,now(),now(),0,0,"NULL",1,None),
    (19,9,"秦客服","客服专员",rp(),"qin@sf-express.com","qin_cs","0",1,now(),now(),0,0,"NULL",1,None),
    (20,12,"尤经理","大客户经理",rp(),"you@xiaomi.com","you_ka","0",1,now(),now(),0,0,"NULL",1,None),
]
R["supplier_contact"]=supplier_contacts

# Supplier ratings
srid=idg(1)
supplier_ratings=[]
periods=["2024-Q1","2024-Q2","2024-Q3","2024-Q4","2025-Q1"]
for sid in range(1,16):
    for p in periods:
        q=random.randint(75,99)
        d=random.randint(70,98)
        s=random.randint(72,97)
        pr=random.randint(68,95)
        t=(q+d+s+pr)/4
        lv=5 if t>=90 else (4 if t>=80 else (3 if t>=70 else 2))
        supplier_ratings.append((next(srid),sid,p,q,d,s,pr,t,lv,random.randint(1,15),rd(-120,-1),1,now(),now(),0,0,"NULL",1,None))
R["supplier_rating"]=supplier_ratings

# Supplier contracts
scnid=idg(1)
supplier_contracts=[
    (1,"CT2024001",1,1,"华为年度采购框架协议","2024-01-01","2024-12-31",50000000.00,"月结30天","JIT交付","违约金为合同金额10%",None,"2024-01-05","张三",1,1,now(),now(),0,0,"NULL",1,"年度框架协议"),
    (2,"CT2024002",2,2,"富士康代工服务协议","2024-01-01","2024-12-31",80000000.00,"预付30%月结70%","按订单生产","延迟交付按日0.5%扣款",None,"2024-01-10","张三",1,1,now(),now(),0,0,"NULL",1,"代工协议"),
    (3,"CT2024003",4,1,"伊利乳制品采购合同","2024-02-01","2024-12-31",20000000.00,"货到付款","每周配送2次","质量问题无条件退换",None,"2024-02-05","赵六",1,1,now(),now(),0,0,"NULL",1,"乳制品采购"),
    (4,"CT2024004",5,1,"宝洁日化产品采购协议","2024-03-01","2025-02-28",15000000.00,"月结45天","每月15日配送","首批支持退换",None,"2024-03-01","赵六",1,1,now(),now(),0,0,"NULL",1,"日化采购"),
    (5,"CT2024005",6,2,"耐克运动鞋服经销合同","2024-01-01","2024-12-31",30000000.00,"预付20%季结80%","季度补货","季末可退换20%",None,"2024-01-15","李四",1,1,now(),now(),0,0,"NULL",1,"经销合同"),
    (6,"CT2024006",9,3,"顺丰物流运输服务协议","2024-01-01","2024-12-31",10000000.00,"月结30天","次日达","货损全额赔付",None,"2024-01-08","王五",1,1,now(),now(),0,0,"NULL",1,"物流协议"),
    (7,"CT2024007",10,1,"可口可乐饮料采购合同","2024-04-01","2025-03-31",12000000.00,"月结30天","每周配送","夏季旺季优先供应",None,"2024-04-01","赵六",1,1,now(),now(),0,0,"NULL",1,"饮料采购"),
    (8,"CT2024008",14,1,"农夫山泉饮用水采购协议","2024-05-01","2025-04-30",8000000.00,"货到付款","每周配送3次","支持季节性调价",None,"2024-05-05","赵六",1,1,now(),now(),0,0,"NULL",1,"饮用水采购"),
    (9,"CT2024009",11,1,"联想电脑设备采购合同","2024-06-01","2025-05-31",25000000.00,"预付30%到货70%","按订单交付","质保三年上门",None,"2024-06-01","张三",1,1,now(),now(),0,0,"NULL",1,"IT设备采购"),
    (10,"CT2024010",3,2,"京东渠道供货协议","2024-07-01","2025-06-30",18000000.00,"实销实结","JIT补货","滞销可退",None,"2024-07-01","李四",1,1,now(),now(),0,0,"NULL",1,"渠道协议"),
]
R["supplier_contract"]=supplier_contracts

# Supplier products
sppid=idg(1)
supplier_products=[]
# Map some suppliers to SKUs
supplier_skus={
    1:[1,2,3,5,13], 2:[1,2,4], 3:[1,2,3,4,5,10,11,13,14,15],
    4:[12,17], 5:[8,9,18], 6:[10,20], 7:[11,15], 8:[19],
    9:[], 10:[7,17], 11:[4,13,14], 12:[3,5], 13:[6,16],
    14:[17], 15:[19],
}
for sid, sku_list in supplier_skus.items():
    for sku_id in sku_list:
        sku=next(s for s in skus if s[0]==sku_id)
        cp=sku[8]
        pp=cp*(1+random.uniform(0.05,0.25))
        supplier_products.append((next(sppid),sid,sku_id,sku[1],sku[3],pp,13.0,1.0,random.randint(3,14),1 if sid in [1,2] else 0,rd(-180,0),rd(180,365),1,now(),now(),0,0,"NULL",1,None))
R["supplier_product"]=supplier_products

# ============================================================
# 5. 仓库与库位
# ============================================================
wid=idg(1)
warehouses=[
    (1,"WH0001","上海中心仓",1,3,"上海市","浦东新区","祝桥镇","祝潘公路1号","张仓管",rp(),15000.00,45000.0000,1,1,now(),now(),0,0,"NULL",1,"华东主仓"),
    (2,"WH0002","杭州区域仓",2,3,"浙江省","杭州市","萧山区","萧山经济技术开发区","李仓管",rp(),8000.00,24000.0000,0,1,now(),now(),0,0,"NULL",1,"浙江区域仓"),
    (3,"WH0003","南京区域仓",2,3,"江苏省","南京市","江宁区","江宁开发区","王仓管",rp(),6000.00,18000.0000,0,1,now(),now(),0,0,"NULL",1,"江苏区域仓"),
    (4,"WH0004","广州中心仓",1,3,"广东省","广州市","白云区","白云物流园","陈仓管",rp(),12000.00,36000.0000,0,1,now(),now(),0,0,"NULL",1,"华南主仓"),
    (5,"WH0005","北京中心仓",1,3,"北京市","大兴区","亦庄","亦庄物流园","刘仓管",rp(),10000.00,30000.0000,0,1,now(),now(),0,0,"NULL",1,"华北主仓"),
    (6,"WH0006","深圳前置仓",3,3,"广东省","深圳市","南山区","科技园","赵仓管",rp(),2000.00,6000.0000,0,1,now(),now(),0,0,"NULL",1,"华南前置仓"),
]
R["warehouse"]=warehouses

wlid=idg(1)
locations=[]
zone_types={"A":"拣货位","B":"存储位","C":"暂存位","D":"退货位","E":"不良品位"}
for wh in warehouses:
    wh_id=wh[0]
    # A区: 拣货位 20个
    for i in range(1,21):
        locations.append((next(wlid),f"{wh[1]}-A-{i:03d}",wh_id,"A",f"{((i-1)//5)+1:02d}",f"{((i-1)%5)+1:02d}",random.randint(1,4),f"{i:03d}",1,500.0,2.0,1,1,now(),now(),0,0,"NULL",1,None))
    # B区: 存储位 30个
    for i in range(1,31):
        locations.append((next(wlid),f"{wh[1]}-B-{i:03d}",wh_id,"B",f"{((i-1)//6)+1:02d}",f"{((i-1)%6)+1:02d}",random.randint(1,5),f"{i:03d}",2,2000.0,8.0,1,1,now(),now(),0,0,"NULL",1,None))
    # C区: 暂存位 5个
    for i in range(1,6):
        locations.append((next(wlid),f"{wh[1]}-C-{i:03d}",wh_id,"C","01","01",1,f"{i:03d}",3,800.0,3.0,1,1,now(),now(),0,0,"NULL",1,None))
R["warehouse_location"]=locations

# ============================================================
# 6. 客户管理
# ============================================================
clid=idg(1)
customer_levels=[
    (1,"LV01","普通会员",0.00,9999.99,100.00,5000.00,30,1,now(),now(),0,0,"NULL",1,None),
    (2,"LV02","银卡会员",10000.00,49999.99,95.00,20000.00,60,1,now(),now(),0,0,"NULL",1,None),
    (3,"LV03","金卡会员",50000.00,199999.99,90.00,50000.00,90,1,now(),now(),0,0,"NULL",1,None),
    (4,"LV04","钻石会员",200000.00,None,85.00,200000.00,120,1,now(),now(),0,0,"NULL",1,None),
]
R["customer_level"]=customer_levels

cuid=idg(1)
customers=[
    (1,"CUST0001","阿里巴巴集团",1,4,200000.00,85000.00,120,"马经理",rp(),"ma@alibaba.com","浙江省","杭州市","余杭区","文一西路969号","9133010079965XXXXX","中国工商银行杭州分行","1202020011112222",3,"2015-03-15","2025-04-10",2850000.00,152,1,now(),now(),0,0,"NULL",1,"电商大客户"),
    (2,"CUST0002","腾讯科技有限公司",1,4,200000.00,120000.00,120,"张经理",rp(),"zhang@tencent.com","广东省","深圳市","南山区","科技园","9144030019238AAAA","招商银行深圳分行","7555010011113333",4,"2016-06-20","2025-04-15",4200000.00,210,1,now(),now(),0,0,"NULL",1,"互联网巨头"),
    (3,"CUST0003","美团点评有限公司",1,3,50000.00,32000.00,90,"李采购",rp(),"li@meituan.com","北京市","朝阳区","望京","望京街","9111010839966BBBB","中国银行北京分行","1101010011114444",5,"2017-09-10","2025-04-12",680000.00,85,1,now(),now(),0,0,"NULL",1,"本地生活平台"),
    (4,"CUST0004","字节跳动科技有限公司",1,4,200000.00,95000.00,120,"王采购",rp(),"wang@bytedance.com","北京市","海淀区","知春路","中航广场","9111010859967CCCC","建设银行北京分行","1101080011115555",6,"2018-01-05","2025-04-18",3100000.00,168,1,now(),now(),0,0,"NULL",1,"内容平台巨头"),
    (5,"CUST0005","拼多多有限公司",1,3,50000.00,28000.00,90,"赵经理",rp(),"zhao@pinduoduo.com","上海市","长宁区","娄山关路","金虹桥国际中心","9131000039968DDDD","浦发银行上海分行","3101050011116666",7,"2019-04-22","2025-04-08",520000.00,72,1,now(),now(),0,0,"NULL",1,"社交电商"),
    (6,"CUST0006","苏宁易购集团股份有限公司",1,3,50000.00,45000.00,90,"孙采购",rp(),"sun@suning.com","江苏省","南京市","玄武区","苏宁大道","9132000013222EEEE","南京银行","3201020011117777",8,"2014-08-18","2025-04-14",890000.00,110,1,now(),now(),0,0,"NULL",1,"零售连锁"),
    (7,"CUST0007","永辉超市股份有限公司",1,2,20000.00,15000.00,60,"周经理",rp(),"zhou@yonghui.com.cn","福建省","福州市","鼓楼区","西二环中路","9135000013222FFFF","兴业银行福州分行","3501020011118888",9,"2013-05-30","2025-04-11",320000.00,65,1,now(),now(),0,0,"NULL",1,"连锁超市"),
    (8,"CUST0008","京东七鲜超市",3,2,20000.00,12000.00,60,"吴采购",rp(),"wu@7fresh.com","北京市","大兴区","亦庄","科创街","9111030213222GGGG","招商银行北京分行","1101010011119999",3,"2020-02-14","2025-04-16",280000.00,58,1,now(),now(),0,0,"NULL",1,"新零售"),
    (9,"CUST0009","盒马鲜生",3,2,20000.00,18000.00,60,"郑经理",rp(),"zheng@hema.com","上海市","浦东新区","陆家嘴","世纪大道","9131000013222HHHH","上海银行","3101150011110000",4,"2019-07-01","2025-04-09",350000.00,70,1,now(),now(),0,0,"NULL",1,"新零售"),
    (10,"CUST0010","大润发流通事业股份有限公司",1,2,20000.00,22000.00,60,"钱采购",rp(),"qian@rt-mart.com.cn","台湾省","台北市","中山区","中山北路","9135000013222IIII","中国信托商业银行","3501020011111111",5,"2012-11-08","2025-04-13",410000.00,82,1,now(),now(),0,0,"NULL",1,"大卖场"),
    (11,"CUST0011","华润万家有限公司",1,2,20000.00,19000.00,60,"冯经理",rp(),"feng@vanguard.com.cn","广东省","深圳市","罗湖区","深南东路","9144030013222JJJJ","平安银行深圳分行","4403010011112222",6,"2011-09-25","2025-04-17",380000.00,78,1,now(),now(),0,0,"NULL",1,"连锁超市"),
    (12,"CUST0012","天虹数科商业股份有限公司",1,2,20000.00,8000.00,60,"陈采购",rp(),"chen@rainbow.cn","广东省","深圳市","福田区","福华三路","9144030013222KKKK","招商银行深圳分行","4403040011113333",7,"2010-04-12","2025-04-07",190000.00,45,1,now(),now(),0,0,"NULL",1,"百货零售"),
    (13,"CUST0013","步步高商业连锁股份有限公司",1,1,5000.00,3500.00,30,"褚经理",rp(),"chu@betterbuy.com","湖南省","湘潭市","雨湖区","建设北路","9143030013222LLLL","长沙银行","4303020011114444",8,"2015-06-18","2025-04-06",85000.00,32,1,now(),now(),0,0,"NULL",1,"区域零售"),
    (14,"CUST0014","联华超市股份有限公司",1,1,5000.00,4200.00,30,"卫采购",rp(),"wei@lianhua.com.cn","上海市","黄浦区","南京东路","南京东路800号","9131000013222MMMM","上海银行","3101010011115555",9,"2014-02-28","2025-04-19",95000.00,38,1,now(),now(),0,0,"NULL",1,"连锁超市"),
    (15,"CUST0015","家乐福中国",1,2,20000.00,25000.00,60,"蒋经理",rp(),"jiang@carrefour.com.cn","上海市","徐汇区","肇嘉浜路","肇嘉浜路1288号","9131000013222NNNN","汇丰银行上海分行","3101040011116666",3,"2009-12-01","2025-04-05",450000.00,90,1,now(),now(),0,0,"NULL",1,"外资大卖场"),
    (16,"CUST0016","物美科技集团有限公司",1,2,20000.00,16000.00,60,"沈采购",rp(),"shen@wumart.com","北京市","石景山区","石景山路","石景山路22号","9111000013222OOOO","北京银行","1101070011117777",4,"2013-08-08","2025-04-04",310000.00,68,1,now(),now(),0,0,"NULL",1,"连锁超市"),
    (17,"CUST0017","叮咚买菜",4,1,5000.00,2800.00,30,"韩经理",rp(),"han@ddmc.com","上海市","浦东新区","张江","盛夏路","9131000013222PPPP","招商银行上海分行","3101150011118888",5,"2020-06-01","2025-04-03",72000.00,28,1,now(),now(),0,0,"NULL",1,"前置仓电商"),
    (18,"CUST0018","每日优鲜",4,1,5000.00,1200.00,30,"杨采购",rp(),"yang@missfresh.com","北京市","朝阳区","望京","望京街","9111010513222QQQQ","建设银行北京分行","1101050011119999",6,"2019-03-15","2025-03-28",35000.00,18,1,now(),now(),0,0,"NULL",1,"生鲜电商"),
    (19,"CUST0019","中石化易捷销售有限公司",1,3,50000.00,38000.00,90,"朱经理",rp(),"zhu@sinopec.com","北京市","朝阳区","朝阳门","朝阳门北大街22号","9111000013222RRRR","工商银行北京分行","1101050022220000",7,"2016-01-20","2025-04-02",650000.00,95,1,now(),now(),0,0,"NULL",1,"便利店"),
    (20,"CUST0020","中石油昆仑好客有限公司",1,3,50000.00,32000.00,90,"秦采购",rp(),"qin@petrochina.com.cn","北京市","西城区","金融街","金融大街1号","9111000013222SSSS","中国银行北京分行","1101020022221111",8,"2017-04-10","2025-04-01",580000.00,88,1,now(),now(),0,0,"NULL",1,"便利店"),
]
R["customer"]=customers

# ============================================================
# 7. 采购管理
# ============================================================
# Purchase requests
prid=idg(1)
purchase_requests=[]
purchase_request_items=[]
priid=idg(1)
for i in range(1,16):
    req_no=f"PR2024{i:04d}"
    org=random.choice([2,3,4])
    reqr=random.choice([5,8,12])
    rd_dt=rd(-200,-1)
    exp_dt=rd(5,30)
    total=random.randint(50000,500000)
    qty=random.randint(100,2000)
    stat=random.choice([1,2,3,4])
    apr_stat=2 if stat>=2 else random.choice([0,1,2,3])
    purchase_requests.append((next(prid),req_no,org,reqr,rd_dt,exp_dt,total,qty,"CNY",random.choice([1,2,3]),apr_stat,stat,now(),now(),0,0,"NULL",1,f"常规采购申请{i}"))
    # 2-4 items per request
    for _ in range(random.randint(2,4)):
        sku=random.choice(skus)
        q=random.randint(10,200)
        up=sku[9]
        amt=q*up
        purchase_request_items.append((next(priid),prid.__next__()-1,sku[0],q,up,amt,None,1,now(),now(),0,0,"NULL",1,None))

R["purchase_request"]=purchase_requests
R["purchase_request_item"]=purchase_request_items

# Purchase orders
poid=idg(1)
poiid=idg(1)
purchase_orders=[]
purchase_order_items=[]
for i in range(1,16):
    order_no=f"PO2024{i:04d}"
    req=random.choice(purchase_requests)
    sup=random.choice(suppliers)
    org=req[2]
    buyer=random.choice([5,8,12])
    od_dt=rd(-180,-1)
    exp_dt=rd(5,30)
    total=random.randint(30000,400000)
    qty=random.randint(80,1500)
    disc=random.randint(0,5000)
    tax=round((total-disc)*0.13,4)
    pay=total-disc+tax
    wh=random.choice([1,2,3,4,5,6])
    stat=random.choice([1,2,3,4])
    rs=0 if stat<=1 else random.choice([0,1,2])
    ps=0 if stat<=2 else random.choice([0,1,2])
    is_0=0 if stat<=2 else random.choice([0,1,2])
    purchase_orders.append((next(poid),order_no,req[0],sup[0],org,buyer,od_dt,exp_dt,"NULL",total,qty,disc,tax,pay,"CNY",random.choice([1,2,3,4]),random.choice([30,45,60,90]),wh,"",rs,ps,is_0,stat,now(),now(),0,0,"NULL",1,f"采购订单{i}"))
    for _ in range(random.randint(1,3)):
        sku=random.choice(skus)
        q=random.randint(20,150)
        up=sku[8]
        amt=q*up
        t=round(amt*0.13,4)
        purchase_order_items.append((next(poiid),poid.__next__()-1,None,sku[0],sku[3],sku[4],q,0,0,up,amt,13.0,t,0.0,rd(5,30),1,now(),now(),0,0,"NULL",1,None))

R["purchase_order"]=purchase_orders
R["purchase_order_item"]=purchase_order_items

# Purchase in stock
pisid=idg(1)
pisiid=idg(1)
purchase_in_stocks=[]
purchase_in_stock_items=[]
for po in purchase_orders[:10]:
    if po[26] < 2: continue
    in_no=f"RK2024{pisid.__next__():04d}"
    pisid=idg(pisid.__next__())
    sup=po[3]
    wh=po[16]
    op=random.choice([7,13])
    in_dt=rd(-150,-1)
    tq=random.randint(50,1200)
    ta=random.randint(20000,300000)
    st=random.choice([2,3])
    purchase_in_stocks.append((next(pisid),in_no,po[0],sup,wh,op,in_dt,tq,ta,st,now(),now(),0,0,"NULL",1,None))
    for _ in range(random.randint(1,3)):
        sku=random.choice(skus)
        eq=random.randint(20,100)
        aq=max(0,eq-random.randint(0,3))
        uq=max(0,aq-random.randint(0,2))
        bq=aq-uq
        up=sku[8]
        loc=random.choice(locations)[0]
        bn=f"BN{random.randint(2024001,2024999)}"
        purchase_in_stock_items.append((next(pisiid),pisid.__next__()-1,None,sku[0],sku[3],sku[4],eq,aq,uq,bq,up,aq*up,loc,bn,rd(-200,-100),rd(100,300),2,now(),now(),0,0,"NULL",1,None))

R["purchase_in_stock"]=purchase_in_stocks
R["purchase_in_stock_item"]=purchase_in_stock_items

# Purchase returns
prrid=idg(1)
prriid=idg(1)
purchase_returns=[]
purchase_return_items=[]
for i in range(1,6):
    po=random.choice(purchase_orders)
    ret_no=f"TH2024{i:04d}"
    wh=po[16]
    op=random.choice([7,13])
    ret_dt=rd(-100,-1)
    tq=random.randint(5,50)
    ta=random.randint(2000,50000)
    rs=random.choice([0,1])
    st=random.choice([2,3])
    reason=random.choice(["质量问题","包装破损","数量差异","规格不符","过期临期"])
    purchase_returns.append((next(prrid),ret_no,po[0],None,po[3],wh,op,ret_dt,reason,tq,ta,rs,st,now(),now(),0,0,"NULL",1,None))
    for _ in range(random.randint(1,2)):
        sku=random.choice(skus)
        q=random.randint(5,25)
        up=sku[8]
        purchase_return_items.append((next(prriid),prrid.__next__()-1,None,None,sku[0],sku[3],sku[4],q,up,q*up,reason,None,1,now(),now(),0,0,"NULL",1,None))

R["purchase_return"]=purchase_returns
R["purchase_return_item"]=purchase_return_items

# ============================================================
# 8. 库存管理
# ============================================================
invid=idg(1)
inventories=[]
for sku in skus:
    for wh in warehouses:
        if random.random()>0.6: continue
        aq=random.randint(0,500)
        fq=random.randint(0,50)
        lq=random.randint(0,30)
        ow=random.randint(0,100)
        tq=aq+fq+lq+ow
        ss=random.randint(20,100)
        cp=sku[8]
        tc=tq*cp
        inventories.append((next(invid),sku[0],wh[0],aq,fq,lq,ow,tq,ss,None,cp,tc,1,now(),now(),0,0,"NULL",1,None))

R["inventory"]=inventories

# Inventory batch
ibid=idg(1)
inventory_batches=[]
for inv in inventories:
    if random.random()>0.5: continue
    bn=f"BN{random.randint(2024001,2024999)}"
    loc=random.choice(locations)[0] if random.random()>0.3 else None
    pd=rd(-300,-50)
    ed=rd(50,300)
    aq=max(0,inv[3]-random.randint(0,10))
    fq=random.randint(0,10)
    tq=aq+fq
    cp=inv[11]
    inventory_batches.append((next(ibid),inv[0],inv[1],inv[2],loc,bn,pd,ed,aq,fq,tq,cp,tq*cp,1,now(),now(),0,0,"NULL",1,None))

R["inventory_batch"]=inventory_batches

# Inventory log
ilid=idg(1)
inventory_logs=[]
for i in range(1,51):
    biz_types=[1,2,3,4,5,6,7,8,9]
    bt=random.choice(biz_types)
    biz_no=f"LOG{random.randint(100000,999999)}"
    sku=random.choice(skus)[0]
    wh=random.choice(warehouses)[0]
    loc=random.choice(locations)[0] if random.random()>0.5 else None
    bn=f"BN{random.randint(2024001,2024999)}" if random.random()>0.5 else None
    bq=random.randint(0,500)
    cq=random.randint(-200,200)
    aq=max(0,bq+cq)
    bc=random.uniform(10,5000)
    cc=round(cq*random.uniform(10,5000),4)
    ac=bc+cc
    op=random.choice([7,13])
    ot=rdt(200)
    inventory_logs.append((next(ilid),biz_no,bt,biz_no,sku,wh,loc,bn,bq,cq,ac,bc,cc,ac,op,ot,1,now(),now(),0,0,"NULL",1,None))

R["inventory_log"]=inventory_logs

# Stock transfers
stid=idg(1)
stiid=idg(1)
stock_transfers=[]
stock_transfer_items=[]
for i in range(1,6):
    fw=random.choice(warehouses)[0]
    tw=random.choice([w for w in warehouses if w[0]!=fw])[0]
    ap=random.choice([5,8,12])
    ad=rd(-120,-1)
    sd=rd(-100,0) if random.random()>0.5 else "NULL"
    rd_dt=rd(-80,0) if random.random()>0.5 else "NULL"
    tq=random.randint(50,500)
    ta=random.randint(10000,100000)
    ss=random.choice([0,1,2])
    rs=random.choice([0,1,2])
    st=random.choice([1,2,3,4,5,6])
    stock_transfers.append((next(stid),f"DB2024{i:04d}",fw,tw,random.choice([1,2,3,4]),ap,ad,sd,rd_dt,None,None,tq,ta,ss,rs,st,now(),now(),0,0,"NULL",1,None))
    for _ in range(random.randint(1,3)):
        sku=random.choice(skus)
        q=random.randint(10,100)
        uc=sku[8]
        stock_transfer_items.append((next(stiid),stid.__next__()-1,sku[0],sku[3],None,None,None,q,0,0,uc,q*uc,1,now(),now(),0,0,"NULL",1,None))

R["stock_transfer"]=stock_transfers
R["stock_transfer_item"]=stock_transfer_items

# ============================================================
# 9. 销售管理
# ============================================================
soid=idg(1)
soiid=idg(1)
sales_orders=[]
sales_order_items=[]
for i in range(1,21):
    order_no=f"SO2024{i:04d}"
    cust=random.choice(customers)
    rep=random.choice([3,6,9,14])
    org=random.choice([2,3,4])
    wh=random.choice([1,2,3,4,5,6])
    od_dt=rd(-200,-1)
    exp_dt=rd(5,20)
    del_dt=rd(-50,0) if random.random()>0.4 else "NULL"
    total=random.randint(20000,300000)
    qty=random.randint(50,800)
    disc=random.randint(0,10000)
    tax=round((total-disc)*0.13,4)
    pay=total-disc+tax
    paid=round(pay*random.uniform(0,1),4)
    dt=random.choice([1,2,3,4])
    ds=0 if del_dt=="NULL" else random.choice([1,2])
    ps=0 if paid==0 else (1 if paid<pay else 2)
    is_0=random.choice([0,1,2])
    st=random.choice([1,2,3,4,5])
    sales_orders.append((next(soid),order_no,cust[0],rep,org,wh,od_dt,exp_dt,del_dt,total,qty,disc,tax,pay,paid,"CNY",dt,"",cust[4],cust[5],ds,ps,is_0,st,now(),now(),0,0,"NULL",1,f"销售订单{i}"))
    for _ in range(random.randint(1,4)):
        sku=random.choice(skus)
        q=random.randint(10,80)
        up=sku[9]
        amt=q*up
        t=round(amt*0.13,4)
        sales_order_items.append((next(soiid),soid.__next__()-1,sku[0],sku[3],sku[4],q,0,0,up,amt,13.0,t,0.0,wh,1,now(),now(),0,0,"NULL",1,None))

R["sales_order"]=sales_orders
R["sales_order_item"]=sales_order_items

# Sales out stock
sosid=idg(1)
sales_out_stocks=[]
for so in sales_orders[:10]:
    if so[26] < 3: continue
    out_no=f"CK2024{sosid.__next__():04d}"
    sosid=idg(sosid.__next__())
    cust=so[2]
    wh=so[5]
    op=random.choice([7,13])
    out_dt=rd(-100,-1)
    tq=random.randint(30,600)
    ta=random.randint(15000,250000)
    wb=f"SF{random.randint(1000000000,9999999999)}"
    car=random.choice([1,2,3,4,5])
    st=random.choice([2,3])
    sales_out_stocks.append((next(sosid),out_no,so[0],cust,wh,op,out_dt,tq,ta,wb,car,st,now(),now(),0,0,"NULL",1,None))

R["sales_out_stock"]=sales_out_stocks

# Sales returns
srid=idg(1)
sriid=idg(1)
sales_returns=[]
sales_return_items=[]
for i in range(1,6):
    so=random.choice(sales_orders)
    ret_no=f"XH2024{i:04d}"
    wh=so[5]
    op=random.choice([7,13])
    ret_dt=rd(-100,-1)
    tq=random.randint(5,30)
    ta=random.randint(3000,30000)
    rs=random.choice([0,1])
    st=random.choice([2,3])
    reason=random.choice(["客户退货","质量问题","错发","七天无理由","运输损坏"])
    sales_returns.append((next(srid),ret_no,so[0],None,so[2],wh,op,ret_dt,reason,tq,ta,rs,st,now(),now(),0,0,"NULL",1,None))
    for _ in range(random.randint(1,2)):
        sku=random.choice(skus)
        q=random.randint(2,15)
        up=sku[9]
        sales_return_items.append((next(sriid),srid.__next__()-1,None,sku[0],sku[3],sku[4],q,up,q*up,13.0,round(q*up*0.13,4),reason,None,wh,None,1,now(),now(),0,0,"NULL",1,None))

R["sales_return"]=sales_returns
R["sales_return_item"]=sales_return_items

# ============================================================
# 10. WMS
# ============================================================
wiid=idg(1)
wiiid=idg(1)
wms_inbounds=[]
wms_inbound_items=[]
for i in range(1,11):
    in_no=f"RKW2024{i:04d}"
    it=random.choice([1,2,3,4])
    st=1
    src_type=random.choice([1,2,3])
    src_id=random.choice(purchase_orders)[0]
    src_no=f"PO2024{random.randint(1,15):04d}"
    wh=random.choice(warehouses)[0]
    sup=random.choice(suppliers)[0]
    tsc=random.randint(1,5)
    tq=random.randint(50,800)
    ta=random.randint(20000,250000)
    ad=rd(-150,-1)
    op=random.choice([7,13])
    qcs=random.choice([0,1,2,3])
    st_wms=random.choice([1,2,3,4,5,6])
    wms_inbounds.append((next(wiid),in_no,it,st,src_type,src_id,src_no,wh,sup,tsc,tq,ta,ad,ad,op,qcs,st_wms,now(),now(),0,0,"NULL",1,None))
    for _ in range(random.randint(1,4)):
        sku=random.choice(skus)
        eq=random.randint(10,100)
        aq=max(0,eq-random.randint(0,3))
        uq=max(0,aq-random.randint(0,2))
        bq=aq-uq
        up=sku[8]
        loc=random.choice(locations)[0]
        bn=f"BN{random.randint(2024001,2024999)}"
        wms_inbound_items.append((next(wiiid),wiid.__next__()-1,sku[0],sku[3],eq,aq,uq,bq,up,aq*up,loc,bn,rd(-200,-50),rd(50,300),1,now(),now(),0,0,"NULL",1,None))

R["wms_inbound"]=wms_inbounds
R["wms_inbound_item"]=wms_inbound_items

woid=idg(1)
woiid=idg(1)
wms_outbounds=[]
wms_outbound_items=[]
for i in range(1,11):
    out_no=f"CKW2024{i:04d}"
    ot=random.choice([1,2,3,4])
    st=1
    src_type=random.choice([1,2,3])
    src_id=random.choice(sales_orders)[0]
    src_no=f"SO2024{random.randint(1,20):04d}"
    wh=random.choice(warehouses)[0]
    cust=random.choice(customers)[0]
    tsc=random.randint(1,5)
    tq=random.randint(30,600)
    ta=random.randint(15000,200000)
    pr=random.choice([1,2,3])
    ps=0
    pks=random.choice([0,1])
    ss=random.choice([0,1])
    st_wms=random.choice([1,2,3,4,5,6,7,8])
    wms_outbounds.append((next(woid),out_no,ot,st,src_type,src_id,src_no,wh,cust,tsc,tq,ta,pr,None,ps,pks,ss,st_wms,now(),now(),0,0,"NULL",1,None))
    for _ in range(random.randint(1,4)):
        sku=random.choice(skus)
        eq=random.randint(10,80)
        aq=max(0,eq-random.randint(0,5))
        up=sku[9]
        loc=random.choice(locations)[0]
        bn=f"BN{random.randint(2024001,2024999)}"
        wms_outbound_items.append((next(woiid),woid.__next__()-1,sku[0],sku[3],eq,aq,up,aq*up,loc,bn,1,now(),now(),0,0,"NULL",1,None))

R["wms_outbound"]=wms_outbounds
R["wms_outbound_item"]=wms_outbound_items

# Waves
waveid=idg(1)
waves=[]
for i in range(1,6):
    wh=random.choice(warehouses)[0]
    wt=random.choice([1,2,3])
    oc=random.randint(5,50)
    sc=random.randint(10,80)
    tq=random.randint(100,500)
    st=random.choice([1,2,3])
    waves.append((next(waveid),f"BW2024{i:04d}",wh,wt,oc,sc,tq,rdt(100),rdt(50),st,now(),now(),0,0,"NULL",1,None))

R["wave"]=waves

# Pick orders
pkid=idg(1)
pick_orders=[]
for i in range(1,11):
    w=random.choice(waves)
    wh=w[2]
    pt=random.choice([1,2,3])
    pkr=random.choice([7,13])
    sc=random.randint(5,30)
    tq=random.randint(50,300)
    st=random.choice([1,2,3,4])
    pick_orders.append((next(pkid),f"JD2024{i:04d}",w[0],wh,pt,pkr,rdt(80),rdt(40),sc,tq,st,now(),now(),0,0,"NULL",1,None))

R["pick_order"]=pick_orders

# Pick items
pkiid=idg(1)
pick_items=[]
for pk in pick_orders:
    for _ in range(random.randint(2,5)):
        sku=random.choice(skus)
        loc=random.choice(locations)[0]
        eq=random.randint(5,40)
        aq=max(0,eq-random.randint(0,3))
        bn=f"BN{random.randint(2024001,2024999)}"
        pick_items.append((next(pkiid),pk[0],random.choice(wms_outbounds)[0],sku[0],sku[3],loc,bn,eq,aq,1,now(),now(),0,0,"NULL",1,None))

R["pick_order_item"]=pick_items

# ============================================================
# 11. TMS
# ============================================================
carid=idg(1)
carriers=[
    (1,"CR0001","顺丰速运",1,"王经理",rp(),'{"api_url":"https://api.sf-express.com","app_id":"sf123"}',1,1,now(),now(),0,0,"NULL",1,"国内快递龙头"),
    (2,"CR0002","中通快递",1,"李经理",rp(),'{"api_url":"https://api.zto.com","app_id":"zto456"}',0,1,now(),now(),0,0,"NULL",1,"性价比高"),
    (3,"CR0003","京东物流",2,"张经理",rp(),'{"api_url":"https://api.jdl.com","app_id":"jdl789"}',1,1,now(),now(),0,0,"NULL",1,"仓配一体"),
    (4,"CR0004","德邦物流",2,"赵经理",rp(),'{"api_url":"https://api.deppon.com","app_id":"dbp012"}',0,1,now(),now(),0,0,"NULL",1,"大件物流专家"),
    (5,"CR0005","跨越速运",3,"钱经理",rp(),'{"api_url":"https://api.ky-express.com","app_id":"kye345"}',0,1,now(),now(),0,0,"NULL",1,"限时快递"),
]
R["carrier"]=carriers

wbid=idg(1)
waybills=[]
for i in range(1,16):
    car=random.choice(carriers)[0]
    bt=random.choice([1,2,3])
    biz=random.choice(sales_orders if bt==1 else (purchase_returns if bt==2 else stock_transfers))
    biz_no=biz[1]
    sndr=random.choice(["上海中心仓","杭州区域仓","广州中心仓"])
    sndr_p=rp()
    sndr_a="上海市浦东新区祝潘公路1号"
    rcvr=biz[4] if bt==1 else random.choice(customers)[4]
    rcvr_p=rp()
    rcvr_a="北京市朝阳区建国路88号"
    w=random.uniform(0.5,50.0)
    v=random.uniform(0.001,0.5)
    pc=random.randint(1,10)
    fa=random.uniform(10,500)
    ia=random.uniform(0,10000)
    dt=random.choice([1,2,3,4])
    st=random.choice([0,1,2,3,4,5,6,7])
    waybills.append((next(wbid),f"WB{random.randint(1000000000,9999999999)}",car,bt,biz[0],biz_no,sndr,sndr_p,sndr_a,rcvr,rcvr_p,rcvr_a,w,v,pc,fa,ia,dt,rdt(100) if st>0 else "NULL",rdt(50) if st>=5 else "NULL",st,1,now(),now(),0,0,"NULL",1,None))

R["waybill"]=waybills

# Logistics tracks
ltid=idg(1)
logistics_tracks=[]
for wb in waybills:
    for j in range(random.randint(2,6)):
        tc=random.choice(["已揽收","运输中","到达分拨中心","派送中","已签收","异常"])
        loc=random.choice(["上海","杭州","南京","苏州","北京","广州","深圳"])
        logistics_tracks.append((next(ltid),wb[0],rdt(120),tc,None,None,loc,None,1,now(),now(),0,0,"NULL",1,None))

R["logistics_track"]=logistics_tracks

# Freight templates
ftid=idg(1)
freight_templates=[
    (1,"顺丰标准快递",1,1,1.0,12.0,1.0,8.0,99.0,'{"regions":[{"province":"新疆","first_price":20,"continue_price":15}]}',1,now(),now(),0,0,"NULL",1,None),
    (2,"中通经济快递",2,1,1.0,8.0,1.0,4.0,79.0,None,1,now(),now(),0,0,"NULL",1,None),
    (3,"京东特快",3,1,1.0,15.0,1.0,10.0,0.0,None,1,now(),now(),0,0,"NULL",1,None),
    (4,"德邦大件",4,2,10.0,30.0,10.0,15.0,199.0,'{"regions":[{"province":"西藏","first_price":50}]}',1,now(),now(),0,0,"NULL",1,None),
    (5,"跨越次日达",5,1,1.0,25.0,1.0,15.0,0.0,None,1,now(),now(),0,0,"NULL",1,None),
]
R["freight_template"]=freight_templates

# ============================================================
# 12. 财务
# ============================================================
apid=idg(1)
account_payables=[]
for i in range(1,16):
    bt=random.choice([1,2,3,4])
    biz=random.choice(purchase_orders)
    amt=random.randint(10000,300000)
    paid=round(amt*random.uniform(0,1),4)
    unpaid=round(amt-paid,4)
    inv=round(amt*random.uniform(0,1),4)
    uninv=round(amt-inv,4)
    dd=rd(7,90)
    ps=0 if paid==0 else (1 if paid<amt else 2)
    is_0=0 if inv==0 else (1 if inv<amt else 2)
    st=1 if ps<2 else 2
    account_payables.append((next(apid),f"YF2024{i:04d}",bt,biz[0],biz[1],biz[3],amt,paid,unpaid,inv,uninv,dd,"CNY",ps,is_0,st,now(),now(),0,0,"NULL",1,None))

R["account_payable"]=account_payables

arid=idg(1)
account_receivables=[]
for i in range(1,16):
    bt=random.choice([1,2,3])
    biz=random.choice(sales_orders)
    amt=random.randint(5000,200000)
    rec=round(amt*random.uniform(0,1),4)
    unrec=round(amt-rec,4)
    inv=round(amt*random.uniform(0,1),4)
    uninv=round(amt-inv,4)
    dd=rd(7,90)
    rs=0 if rec==0 else (1 if rec<amt else 2)
    is_0=0 if inv==0 else (1 if inv<amt else 2)
    st=1 if rs<2 else 2
    account_receivables.append((next(arid),f"YS2024{i:04d}",bt,biz[0],biz[1],biz[2],amt,rec,unrec,inv,uninv,dd,"CNY",rs,is_0,st,now(),now(),0,0,"NULL",1,None))

R["account_receivable"]=account_receivables

invid2=idg(1)
invoices=[]
for i in range(1,11):
    inv_no=f"FP{random.randint(10000000,99999999)}"
    inv_code=f"{random.randint(1000000000,9999999999)}"
    it=random.choice([1,2,3,4])
    dr=random.choice([1,2])
    bt=random.choice([1,2,3])
    biz=random.choice(purchase_orders if dr==1 else sales_orders)
    party=biz[3] if dr==1 else biz[2]
    pname=next(s[2] for s in suppliers if s[0]==party) if dr==1 else next(c[3] for c in customers if c[0]==party)
    ptax=f"{random.randint(100000000,999999999)}"
    awt=random.randint(10000,200000)
    tx=round(awt*0.13,4)
    awt2=round(awt+tx,4)
    tr=13.0
    idt=rd(-180,-1)
    vs=random.choice([0,1,2])
    st=1
    invoices.append((next(invid2),inv_no,inv_code,it,dr,bt,biz[0],biz[1],party,pname,ptax,awt,tx,awt2,tr,idt,vs,st,now(),now(),0,0,"NULL",1,None))

R["invoice"]=invoices

# Settlements
sid=idg(1)
settlements=[]
settlement_items=[]
siid=idg(1)
for i in range(1,8):
    st=random.choice([1,2,3])
    party=random.choice(suppliers if st==1 else (customers if st==2 else carriers))
    pt=1 if st==1 else (2 if st==2 else 3)
    sd=rd(-90,-30)
    ed=rd(-29,-1)
    ta=random.randint(50000,500000)
    da=random.randint(0,5000)
    aa=ta-da
    ss=random.choice([0,1,2,3])
    settlements.append((next(sid),f"JS2024{i:04d}",st,party[0],pt,sd,ed,ta,da,aa,"CNY",ss,1,now(),now(),0,0,"NULL",1,None))
    for _ in range(random.randint(1,3)):
        src=random.choice(account_payables if st==1 else account_receivables)
        sa=random.uniform(5000,50000)
        settlement_items.append((next(siid),sid.__next__()-1,1 if st==1 else 2,src[0],src[1],src[6],sa,0.0,1,now(),now(),0,0,"NULL",1,None))

R["settlement"]=settlements
R["settlement_item"]=settlement_items

# Payment records
pmid=idg(1)
payment_records=[]
for i in range(1,16):
    pt=random.choice([1,2,3,4])
    biz=random.choice(account_payables if pt in [1,2,3] else account_receivables)
    party=biz[5]
    pt2=1 if pt in [1,2,3] else 2
    amt=round(random.uniform(5000,biz[6]),4)
    pm=random.choice([1,2,3,4,5,6])
    ba=f"6222{random.randint(100000000000,999999999999)}"
    bn=random.choice(["工商银行","建设银行","招商银行","中国银行"])
    pd=rd(-120,-1)
    vn=f"PZ{random.randint(100000,999999)}"
    st=random.choice([1,2,3])
    payment_records.append((next(pmid),f"FK2024{i:04d}",pt,biz[0],biz[1],party,pt2,amt,"CNY",pm,ba,bn,pd,vn,st,now(),now(),0,0,"NULL",1,None))

R["payment_record"]=payment_records

# ============================================================
# 13. 质检
# ============================================================
qcid=idg(1)
qcitems=[]
quality_checks=[]
for i in range(1,8):
    cn=f"ZJ2024{i:04d}"
    ct=random.choice([1,2,3])
    st=1
    src_type=random.choice([1,2,3])
    src=random.choice(wms_inbounds if src_type==1 else (sales_returns if src_type==2 else stock_transfers))
    src_no=src[1]
    wh=random.choice(warehouses)[0]
    sup=random.choice(suppliers)[0] if ct==1 else None
    checker=random.choice([7,13])
    cd=rd(-120,-1)
    tsc=random.randint(1,5)
    tq=random.randint(50,500)
    uq=random.randint(0,20)
    qq=tq-uq
    cr=1 if uq==0 else (2 if qq>0 else 3)
    st2=random.choice([1,2,3])
    quality_checks.append((next(qcid),cn,ct,st,src_type,src[0],src_no,wh,sup,checker,cd,tsc,tq,qq,uq,cr,st2,now(),now(),0,0,"NULL",1,None))
    for _ in range(random.randint(1,3)):
        sku=random.choice(skus)
        cq=random.randint(10,100)
        uq2=random.randint(0,5)
        qq2=cq-uq2
        cr2=1 if uq2==0 else 2
        dt=random.choice(["外观瑕疵","尺寸偏差","功能异常","包装破损","标签错误"])
        dd=random.choice(["轻微划痕","尺寸略大","按键失灵","纸箱破损","日期模糊"])
        disp=random.choice([1,2,3,4])
        qcitems.append((next(qcid),qcid.__next__()-1,sku[0],sku[3],None,cq,qq2,uq2,dt,dd,disp,cr2,1,now(),now(),0,0,"NULL",1,None))

R["quality_check"]=quality_checks
R["quality_check_item"]=qcitems

# ============================================================
# 14. 审批流水
# ============================================================
appid=idg(1)
approval_records=[]
for i in range(1,21):
    bt=random.choice(["purchase_request","supplier_contract","purchase_return","sales_return","purchase_order"])
    biz=random.choice(purchase_requests if bt=="purchase_request" else (supplier_contracts if bt=="supplier_contract" else (purchase_returns if bt=="purchase_return" else (sales_returns if bt=="sales_return" else purchase_orders))))
    step=random.choice([1,2,3])
    sn=random.choice(["部门经理审批","财务审批","总经理审批","采购总监审批","销售总监审批"])
    apvr=random.choice([2,3,4,5])
    apvn=next(u[3] for u in users if u[0]==apvr)
    act=random.choice([1,2,3,4])
    ac=random.choice(["同意","驳回","转交","撤回"])
    at=rdt(100)
    na=None
    approval_records.append((next(appid),bt,biz[0],biz[1],step,sn,apvr,apvn,act,ac,at,na,1,now(),now(),0,0))

R["approval_record"]=approval_records

# ============================================================
# 15. 操作日志
# ============================================================
olid=idg(1)
operation_logs=[]
for i in range(1,31):
    uid=random.choice(users)[0]
    un=next(u[3] for u in users if u[0]==uid)
    bt=random.choice(["purchase_request","purchase_order","sales_order","inventory","supplier"])
    biz=random.choice(purchase_requests if bt=="purchase_request" else (purchase_orders if bt=="purchase_order" else (sales_orders if bt=="sales_order" else (inventories if bt=="inventory" else suppliers))))
    act=random.choice(["create","update","delete","approve","cancel"])
    ad=random.choice(["创建采购申请","更新订单状态","删除商品","审批通过","取消订单"])
    bd=None
    afd=None
    df=None
    ip=f"192.168.1.{random.randint(100,200)}"
    ua="Mozilla/5.0"
    ot=rdt(200)
    operation_logs.append((next(olid),uid,un,bt,biz[0],biz[1],act,ad,bd,afd,df,ip,ua,ot,1))

R["operation_log"]=operation_logs

# ============================================================
# 16. 客户统计
# ============================================================
csid=idg(1)
customer_stats=[]
for c in customers:
    for m in range(-5,1):
        sd=(datetime.now()+timedelta(days=m*30)).strftime("%Y-%m-%d")
        tda=random.randint(50000,500000)
        tdc=random.randint(10,100)
        ma=random.randint(5000,50000)
        mc=random.randint(1,20)
        ldd=rd(-30,0)
        cu=random.randint(1000,50000)
        customer_stats.append((next(csid),c[0],f"'{sd}'",tda,tdc,ma,mc,ldd,cu,now()))

R["customer_stat"]=customer_stats

# ============================================================
# 17. 预警规则与通知
# ============================================================
ruleid=idg(1)
alert_rules=[
    (1,"RULE001","库存安全预警",1,"inventory",'{"field":"available_qty","op":"lt","value":"safety_stock"}','["email","system"]',"[1,2,3]","[2,6]",0,0,None,1,now(),now(),0,0,"NULL",1,"库存低于安全库存时触发"),
    (2,"RULE002","合同到期预警",2,"supplier_contract",'{"field":"end_date","op":"lte","value":"advance_30d"}','["email","sms"]',"[1,2]","[2]",30,1,1440,1,now(),now(),0,0,"NULL",1,"合同到期前30天预警"),
    (3,"RULE003","订单超期预警",3,"purchase_order",'{"field":"expect_date","op":"lt","value":"today"}','["system"]',"[5,8]","[3]",0,1,60,1,now(),now(),0,0,"NULL",1,"采购订单超期未到货预警"),
    (4,"RULE004","付款到期预警",4,"account_payable",'{"field":"due_date","op":"lte","value":"advance_7d"}','["email","system"]',"[10,15]","[7]",7,1,1440,1,now(),now(),0,0,"NULL",1,"应付单到期前7天预警"),
    (5,"RULE005","质检异常预警",5,"quality_check",'{"field":"check_result","op":"eq","value":"2"}','["email","sms","system"]',"[1,8]","[2,8]",0,0,None,1,now(),now(),0,0,"NULL",1,"质检部分合格或不合格时触发"),
]
R["alert_rule"]=alert_rules

notid=idg(1)
notifications=[]
for i in range(1,21):
    rule=random.choice(alert_rules)
    bt=rule[5]
    biz=random.choice(inventories if bt=="inventory" else (supplier_contracts if bt=="supplier_contract" else (purchase_orders if bt=="purchase_order" else (account_payables if bt=="account_payable" else quality_checks))))
    title=random.choice(["库存预警","合同即将到期","订单超期","付款提醒","质检异常"])
    content=f"{title}: 业务单号 {biz[1]} 需要关注"
    nt=random.choice([1,2,3])
    rcv=random.choice(users)[0]
    rnm=next(u[3] for u in users if u[0]==rcv)
    ir=random.choice([0,1])
    rt=rdt(100) if ir==1 else "NULL"
    st=1
    notifications.append((next(notid),rule[0],bt,biz[0],biz[1],title,content,nt,rcv,rnm,ir,rt,now(),st,now()))

R["notification"]=notifications

# ============================================================
# 输出 SQL 文件
# ============================================================

column_map={
    "organization": ["id","org_code","org_name","org_type","parent_id","level","path","leader_id","phone","email","address","sort_order","status","created_at","updated_at","created_by","updated_by","deleted_at","version","remark"],
    "sys_user": ["id","username","password","real_name","employee_no","org_id","dept_id","phone","email","avatar","gender","status","last_login_time","last_login_ip","created_at","updated_at","created_by","updated_by","deleted_at","version","remark"],
    "sys_role": ["id","role_code","role_name","role_type","data_scope","status","created_at","updated_at","created_by","updated_by","deleted_at","version","remark"],
    "user_role": ["id","user_id","role_id","created_at"],
    "dict_type": ["id","dict_name","dict_code","description","status","created_at","updated_at","created_by","updated_by","deleted_at","version","remark"],
    "dict_data": ["id","dict_type_id","dict_label","dict_value","sort_order","is_default","status","created_at","updated_at","created_by","updated_by","deleted_at","version","remark"],
    "sys_config": ["id","config_key","config_value","config_type","description","status","created_at","updated_at","created_by","updated_by","deleted_at","version","remark"],
    "category": ["id","category_code","category_name","parent_id","level","path","sort_order","icon","status","created_at","updated_at","created_by","updated_by","deleted_at","version","remark"],
    "brand": ["id","brand_code","brand_name","brand_name_en","logo_url","website","description","status","created_at","updated_at","created_by","updated_by","deleted_at","version","remark"],
    "product_spu": ["id","spu_code","spu_name","category_id","brand_id","unit","weight","volume","barcode","spec_template","description","main_image","images","status","created_at","updated_at","created_by","updated_by","deleted_at","version","remark"],
    "product_sku": ["id","sku_code","spu_id","sku_name","sku_specs","barcode","weight","volume","cost_price","sale_price","market_price","status","created_at","updated_at","created_by","updated_by","deleted_at","version","remark"],
    "product_price": ["id","sku_id","price_type","price","min_qty","max_qty","effective_date","expiry_date","status","created_at","updated_at","created_by","updated_by","deleted_at","version","remark"],
    "product_barcode": ["id","sku_id","barcode","barcode_type","qty_ratio","is_primary","status","created_at","updated_at","created_by","updated_by","deleted_at","version","remark"],
    "supplier": ["id","supplier_code","supplier_name","supplier_type","credit_level","cooperate_status","contact_name","contact_phone","contact_email","province","city","district","address","bank_name","bank_account","tax_no","registered_capital","establish_date","legal_person","business_scope","audit_status","status","created_at","updated_at","created_by","updated_by","deleted_at","version","remark"],
    "supplier_contact": ["id","supplier_id","contact_name","position","phone","email","wechat","is_primary","status","created_at","updated_at","created_by","updated_by","deleted_at","version","remark"],
    "supplier_rating": ["id","supplier_id","rating_period","quality_score","delivery_score","service_score","price_score","total_score","rating_level","evaluator_id","evaluate_date","status","created_at","updated_at","created_by","updated_by","deleted_at","version","remark"],
    "supplier_contract": ["id","contract_no","supplier_id","contract_type","contract_name","start_date","end_date","amount_limit","payment_terms","delivery_terms","penalty_clause","attachment_url","sign_date","signatory","audit_status","status","created_at","updated_at","created_by","updated_by","deleted_at","version","remark"],
    "supplier_product": ["id","supplier_id","sku_id","supplier_sku_code","supplier_sku_name","purchase_price","tax_rate","min_order_qty","lead_time_days","is_primary","effective_date","expiry_date","status","created_at","updated_at","created_by","updated_by","deleted_at","version","remark"],
    "purchase_request": ["id","request_no","org_id","requester_id","request_date","expect_date","total_amount","total_qty","currency","priority","approval_status","status","created_at","updated_at","created_by","updated_by","deleted_at","version","remark"],
    "purchase_request_item": ["id","request_id","sku_id","qty","unit_price","amount","reason","status","created_at","updated_at","created_by","updated_by","deleted_at","version","remark"],
    "purchase_order": ["id","order_no","request_id","supplier_id","org_id","buyer_id","order_date","expect_date","arrive_date","total_amount","total_qty","discount_amount","tax_amount","payable_amount","currency","payment_terms","payment_days","warehouse_id","delivery_address","receive_status","pay_status","invoice_status","status","created_at","updated_at","created_by","updated_by","deleted_at","version","remark"],
    "purchase_order_item": ["id","order_id","request_item_id","sku_id","sku_name","sku_specs","qty","received_qty","returned_qty","unit_price","amount","tax_rate","tax_amount","discount_rate","delivery_date","status","created_at","updated_at","created_by","updated_by","deleted_at","version","remark"],
    "purchase_in_stock": ["id","in_stock_no","order_id","supplier_id","warehouse_id","operator_id","in_stock_date","total_qty","total_amount","status","created_at","updated_at","created_by","updated_by","deleted_at","version","remark"],
    "purchase_in_stock_item": ["id","in_stock_id","order_item_id","sku_id","sku_name","sku_specs","expect_qty","actual_qty","qualified_qty","unqualified_qty","unit_price","amount","location_id","batch_no","production_date","expiry_date","status","created_at","updated_at","created_by","updated_by","deleted_at","version","remark"],
    "purchase_return": ["id","return_no","order_id","in_stock_id","supplier_id","warehouse_id","operator_id","return_date","return_reason","total_qty","total_amount","refund_status","status","created_at","updated_at","created_by","updated_by","deleted_at","version","remark"],
    "purchase_return_item": ["id","return_id","order_item_id","in_stock_item_id","sku_id","sku_name","sku_specs","return_qty","unit_price","amount","return_reason","batch_no","status","created_at","updated_at","created_by","updated_by","deleted_at","version","remark"],
    "warehouse": ["id","warehouse_code","warehouse_name","warehouse_type","org_id","province","city","district","address","contact_name","contact_phone","area_sqm","capacity_volume","is_default","status","created_at","updated_at","created_by","updated_by","deleted_at","version","remark"],
    "warehouse_location": ["id","location_code","warehouse_id","zone_code","aisle_code","shelf_code","layer_no","position_no","location_type","max_weight","max_volume","is_empty","status","created_at","updated_at","created_by","updated_by","deleted_at","version","remark"],
    "inventory": ["id","sku_id","warehouse_id","available_qty","frozen_qty","locked_qty","on_way_qty","total_qty","safety_stock","max_stock","cost_price","total_cost","status","created_at","updated_at","created_by","updated_by","deleted_at","version","remark"],
    "inventory_log": ["id","log_no","business_type","business_no","sku_id","warehouse_id","location_id","batch_no","before_qty","change_qty","after_qty","before_cost","change_cost","after_cost","operator_id","operation_time","status","created_at","updated_at","created_by","updated_by","deleted_at","version","remark"],
    "stock_transfer": ["id","transfer_no","from_warehouse_id","to_warehouse_id","transfer_type","apply_id","apply_date","ship_date","receive_date","carrier_id","waybill_no","total_qty","total_amount","ship_status","receive_status","status","created_at","updated_at","created_by","updated_by","deleted_at","version","remark"],
    "stock_transfer_item": ["id","transfer_id","sku_id","sku_name","from_location_id","to_location_id","batch_no","transfer_qty","shipped_qty","received_qty","unit_cost","amount","status","created_at","updated_at","created_by","updated_by","deleted_at","version","remark"],
    "customer_level": ["id","level_code","level_name","min_amount","max_amount","discount_rate","credit_limit","credit_days","status","created_at","updated_at","created_by","updated_by","deleted_at","version","remark"],
    "customer": ["id","customer_code","customer_name","customer_type","level_id","credit_limit","credit_used","credit_days","contact_name","contact_phone","contact_email","province","city","district","address","tax_no","bank_name","bank_account","sales_rep_id","first_deal_date","last_deal_date","total_deal_amount","total_deal_count","status","created_at","updated_at","created_by","updated_by","deleted_at","version","remark"],
    "sales_order": ["id","order_no","customer_id","sales_rep_id","org_id","warehouse_id","order_date","expect_date","delivery_date","total_amount","total_qty","discount_amount","tax_amount","payable_amount","paid_amount","currency","delivery_type","delivery_address","receiver_name","receiver_phone","delivery_status","pay_status","invoice_status","status","created_at","updated_at","created_by","updated_by","deleted_at","version","remark"],
    "sales_order_item": ["id","order_id","sku_id","sku_name","sku_specs","qty","delivered_qty","returned_qty","unit_price","amount","tax_rate","tax_amount","discount_rate","warehouse_id","status","created_at","updated_at","created_by","updated_by","deleted_at","version","remark"],
    "sales_out_stock": ["id","out_stock_no","order_id","customer_id","warehouse_id","operator_id","out_stock_date","total_qty","total_amount","waybill_no","carrier_id","status","created_at","updated_at","created_by","updated_by","deleted_at","version","remark"],
    "sales_return": ["id","return_no","order_id","out_stock_id","customer_id","warehouse_id","operator_id","return_date","return_reason","total_qty","total_amount","refund_status","status","created_at","updated_at","created_by","updated_by","deleted_at","version","remark"],
    "sales_return_item": ["id","return_id","order_item_id","sku_id","sku_name","sku_specs","return_qty","unit_price","amount","tax_rate","tax_amount","return_reason","batch_no","warehouse_id","location_id","status","created_at","updated_at","created_by","updated_by","deleted_at","version","remark"],
    "wms_inbound": ["id","inbound_no","inbound_type","source_type","source_id","source_no","warehouse_id","supplier_id","total_sku_count","total_qty","total_amount","arrival_date","actual_date","operator_id","quality_check_status","status","created_at","updated_at","created_by","updated_by","deleted_at","version","remark"],
    "wms_inbound_item": ["id","inbound_id","sku_id","sku_name","expect_qty","actual_qty","qualified_qty","unqualified_qty","unit_price","amount","location_id","batch_no","production_date","expiry_date","status","created_at","updated_at","created_by","updated_by","deleted_at","version","remark"],
    "wms_outbound": ["id","outbound_no","outbound_type","source_type","source_id","source_no","warehouse_id","customer_id","total_sku_count","total_qty","total_amount","priority","wave_id","pick_status","pack_status","ship_status","status","created_at","updated_at","created_by","updated_by","deleted_at","version","remark"],
    "wms_outbound_item": ["id","outbound_id","sku_id","sku_name","expect_qty","actual_qty","unit_price","amount","location_id","batch_no","status","created_at","updated_at","created_by","updated_by","deleted_at","version","remark"],
    "wave": ["id","wave_no","warehouse_id","wave_type","order_count","sku_count","total_qty","start_time","end_time","status","created_at","updated_at","created_by","updated_by","deleted_at","version","remark"],
    "pick_order": ["id","pick_no","wave_id","warehouse_id","pick_type","picker_id","start_time","end_time","sku_count","total_qty","status","created_at","updated_at","created_by","updated_by","deleted_at","version","remark"],
    "pick_order_item": ["id","pick_id","outbound_id","sku_id","sku_name","location_id","batch_no","expect_qty","actual_qty","status","created_at","updated_at","created_by","updated_by","deleted_at","version","remark"],
    "carrier": ["id","carrier_code","carrier_name","carrier_type","contact_name","contact_phone","api_config","is_default","status","created_at","updated_at","created_by","updated_by","deleted_at","version","remark"],
    "waybill": ["id","waybill_no","carrier_id","business_type","business_id","business_no","sender_name","sender_phone","sender_address","receiver_name","receiver_phone","receiver_address","weight","volume","package_count","freight_amount","insured_amount","delivery_type","ship_time","receive_time","logistics_status","status","created_at","updated_at","created_by","updated_by","deleted_at","version","remark"],
    "logistics_track": ["id","waybill_id","track_time","track_content","operator","operator_phone","location","action_code","status","created_at","updated_at","created_by","updated_by","deleted_at","version","remark"],
    "freight_template": ["id","template_name","carrier_id","pricing_type","first_unit","first_price","continue_unit","continue_price","free_threshold","region_rules","status","created_at","updated_at","created_by","updated_by","deleted_at","version","remark"],
    "account_payable": ["id","payable_no","business_type","business_id","business_no","supplier_id","amount","paid_amount","unpaid_amount","invoice_amount","uninvoice_amount","due_date","currency","pay_status","invoice_status","status","created_at","updated_at","created_by","updated_by","deleted_at","version","remark"],
    "account_receivable": ["id","receivable_no","business_type","business_id","business_no","customer_id","amount","received_amount","unreceived_amount","invoice_amount","uninvoice_amount","due_date","currency","receive_status","invoice_status","status","created_at","updated_at","created_by","updated_by","deleted_at","version","remark"],
    "invoice": ["id","invoice_no","invoice_code","invoice_type","direction","business_type","business_id","business_no","party_id","party_name","party_tax_no","amount_without_tax","tax_amount","amount_with_tax","tax_rate","invoice_date","verify_status","status","created_at","updated_at","created_by","updated_by","deleted_at","version","remark"],
    "settlement": ["id","settlement_no","settlement_type","party_id","party_type","start_date","end_date","total_amount","discount_amount","actual_amount","currency","settle_status","status","created_at","updated_at","created_by","updated_by","deleted_at","version","remark"],
    "settlement_item": ["id","settlement_id","source_type","source_id","source_no","amount","settle_amount","discount_amount","status","created_at","updated_at","created_by","updated_by","deleted_at","version","remark"],
    "payment_record": ["id","payment_no","payment_type","business_id","business_no","party_id","party_type","amount","currency","payment_method","bank_account","bank_name","payment_date","voucher_no","status","created_at","updated_at","created_by","updated_by","deleted_at","version","remark"],
    "quality_check": ["id","check_no","check_type","source_type","source_id","source_no","warehouse_id","supplier_id","checker_id","check_date","total_sku_count","total_qty","qualified_qty","unqualified_qty","check_result","status","created_at","updated_at","created_by","updated_by","deleted_at","version","remark"],
    "quality_check_item": ["id","check_id","sku_id","sku_name","batch_no","check_qty","qualified_qty","unqualified_qty","defect_type","defect_desc","disposal_type","check_result","status","created_at","updated_at","created_by","updated_by","deleted_at","version","remark"],
    "approval_record": ["id","biz_type","biz_id","biz_no","step_no","step_name","approver_id","approver_name","action","comment","approve_time","next_approver_id","status","created_at","updated_at","created_by","updated_by"],
    "operation_log": ["id","user_id","user_name","biz_type","biz_id","biz_no","action","action_desc","before_data","after_data","diff_fields","ip_address","user_agent","operation_time","status"],
    "customer_stat": ["id","customer_id","stat_date","total_deal_amount","total_deal_count","month_amount","month_count","last_deal_date","credit_used","updated_at"],
    "alert_rule": ["id","rule_code","rule_name","rule_type","biz_type","condition_expr","notify_channels","notify_users","notify_roles","advance_days","is_repeat","repeat_interval","status","created_at","updated_at","created_by","updated_by","deleted_at","version","remark"],
    "notification": ["id","rule_id","biz_type","biz_id","biz_no","title","content","notify_type","receiver_id","receiver_name","is_read","read_time","send_time","status","created_at"],
}

# Order matters for FK constraints during insert
insert_order=[
    "organization","sys_user","sys_role","user_role","dict_type","dict_data","sys_config",
    "category","brand","product_spu","product_sku","product_price","product_barcode",
    "supplier","supplier_contact","supplier_rating","supplier_contract","supplier_product",
    "warehouse","warehouse_location","customer_level","customer",
    "purchase_request","purchase_request_item","purchase_order","purchase_order_item",
    "purchase_in_stock","purchase_in_stock_item","purchase_return","purchase_return_item",
    "inventory","inventory_batch","inventory_log","stock_transfer","stock_transfer_item",
    "sales_order","sales_order_item","sales_out_stock","sales_return","sales_return_item",
    "wms_inbound","wms_inbound_item","wms_outbound","wms_outbound_item","wave","pick_order","pick_order_item",
    "carrier","waybill","logistics_track","freight_template",
    "account_payable","account_receivable","invoice","settlement","settlement_item","payment_record",
    "quality_check","quality_check_item","approval_record","operation_log","customer_stat","alert_rule","notification",
]

with open(OUTPUT,"w",encoding="utf-8") as f:
    f.write("-- ============================================================\n")
    f.write("-- 企业级供应链中台系统 - 预置数据脚本\n")
    f.write("-- 生成时间: " + datetime.now().strftime("%Y-%m-%d %H:%M:%S") + "\n")
    f.write("-- 说明: 基于 scm_schema.sql 生成的丰富测试数据\n")
    f.write("-- ============================================================\n\n")
    f.write("USE scm_platform;\n\n")
    f.write("SET FOREIGN_KEY_CHECKS = 0;\n\n")
    
    for table in insert_order:
        if table in R and R[table]:
            f.write(f"-- {table}\n")
            f.write(sql(table, column_map[table], R[table]))
            f.write("\n")
    
    f.write("SET FOREIGN_KEY_CHECKS = 1;\n")

print(f"SQL file generated: {OUTPUT}")
print("Summary:")
for table in insert_order:
    if table in R:
        print(f"  {table}: {len(R[table])} rows")
