<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.oreilly.servlet.*" %>
<%@ page import="com.oreilly.servlet.multipart.*" %>
<%@ page import="javax.imageio.*" %>
<%@ page import="java.awt.image.*" %>
<%
	request.setCharacterEncoding("UTF-8");
	session.removeAttribute("outName");

	String filename = "";
	String realFolder = "c:/Upload"; //웹 어플리케이션상의 절대 경로
	String encType = "utf-8"; //인코딩 타입
	int maxSize = 5 * 1024 * 1024; //최대 업로드될 파일의 크기5Mb

	MultipartRequest multi = new MultipartRequest(request, realFolder, maxSize, encType,
			new DefaultFileRenamePolicy());

	String algo = multi.getParameter("algo");
	
	if(algo.equals("0")){
	System.out.println("0이다.");
	Enumeration files = multi.getFileNames();
	String fname = (String) files.nextElement();
	String fileName = multi.getFilesystemName(fname);

	session.setAttribute("fileName", fileName); //세션 정보 설정
 	response.sendRedirect("index.jsp");
	}else{
		filename = (String)session.getAttribute("fileName");
		if(filename==null) {return;}
		//전역 변수 선언
		int[][][] inImage=null;
		int inH=0, inW=0;
		int[][][] outImage=null;
		int outH=0, outW=0;

		//1. JSP 파일 처리
		FileInputStream inFs;
		File inFp = new File("c:/Upload/"+filename);
		//칼라 이미지 처리
		BufferedImage cImage = ImageIO.read(inFp);

		//2. JSP 배열 처리 : 파일 -> 메모리(2차원 배열)
		//*중요* 입력폭, 높이 결정
		inW = cImage.getHeight(); //*높이 반대
		inH = cImage.getWidth();
		outH = inH;
		outW = inW;

		inImage = new int[3][inH][inW];
		//파일 -> 메모리
		for(int i=0; i<inH; i++){
			for(int k=0; k<inW; k++){
				int rgb = cImage.getRGB(i, k);
				int r = (rgb >> 16) & 0xFF;
				int g = (rgb >> 8) & 0xFF;
				int b = (rgb >> 0) & 0xFF;
				inImage[0][i][k] = r;
				inImage[1][i][k] = g;
				inImage[2][i][k] = b;
			}
		}

		// 3. 영상처리 알고리즘 적용하기
		switch(algo){
		case "101":
			// 반전 알고리즘: out = 255-in
			// *중요* 출력 폭, 높이 결정 -> 알고리즘
			outH = inH;
			outW = inW;
			outImage = new int[3][outH][outW];
			// ## 진짜 영상처리 알고리즘 ##
			for(int rgb=0; rgb<3; rgb++) {
				for(int i=0; i<inH; i++){
					for(int k=0; k<inW; k++){
						outImage[rgb][i][k] = 255 - inImage[rgb][i][k];
					}
				}
			}
			break;
		case "102":
			// 밝게/어둡게: out = in + para
			// *중요* 출력 폭, 높이 결정 -> 알고리즘
			outH = inH;
			outW = inW;
			outImage = new int[3][outH][outW];
			// ## 진짜 영상처리 알고리즘 ##
			for(int rgb=0; rgb<3; rgb++){
				for(int i=0; i<inH; i++){
					for(int k=0; k<inW; k++){
						//int v = inImage[rgb][i][k] + Integer.parseInt(para);
						int v = inImage[rgb][i][k] + 50;
						if(v>255)
							v=255;
						if(v<0)
							v=0;
						outImage[rgb][i][k] = v;
					}
				}
			}
			break;
		case "103":
			//그레이 스케일
			outH = inH;
			outW = inW;
			outImage = new int[3][outH][outW];
			for(int i=0; i<inH; i++){
				for(int k=0; k<inW; k++){
					int r = inImage[0][i][k];
					int g = inImage[1][i][k];
					int b = inImage[2][i][k];
					
					int RGB = (int)((r+g+b)/3);
					
					outImage[0][i][k] = RGB;
					outImage[1][i][k] = RGB;
					outImage[2][i][k] = RGB;
				}
			}
			break;
		case "104":
			//흑백처리 알고리즘
			outH = inH;
			outW = inW;
			outImage = new int[3][outH][outW];
			for(int i=0; i<inH; i++){
				for(int k=0; k<inW; k++){
					int r = inImage[0][i][k];
					int g = inImage[1][i][k];
					int b = inImage[2][i][k];
					
					int RGB = (int)((r+g+b)/3);
					if(RGB<127)
						RGB = 0;
					else
						RGB = 255;
					outImage[0][i][k] = RGB;
					outImage[1][i][k] = RGB;
					outImage[2][i][k] = RGB;
				}
			}
			break;
		case "108":
			//파라볼라
			outH = inH;
			outW = inW;
			outImage = new int[3][outH][outW];
			int[] LUT = null;
			LUT = new int[256];
			for (int i = 0; i < 256; i++) {
				double outVal = 255.0 - 255.0 * Math.pow((i / 127.0 - 1), 2.0);
				if (outVal > 255.0)
					outVal = 255.0;
				if (outVal < 0.0)
					outVal = 0.0;
				LUT[i] = (int) outVal;
			}
			for (int rgb = 0; rgb < 3; rgb++) {
				for (int i = 0; i < inH; i++) {
					for (int k = 0; k < inW; k++) {
						int inVal = inImage[rgb][i][k];
						int v = LUT[inVal];
						if (v > 255)
							v = 255;
						if (v < 0)
							v = 0;
						outImage[rgb][i][k] = v;
					}
				}
			}
			break;
		case "202":
			//확대 축소 0~1사이 소수
			outH = inH;
			outW = inW;
			outImage = new int[3][outH][outW];

			Double scale2 = Double.parseDouble("2");
			int C1, C2, C3, C4;
			int newValue, point;

			outH = (int) (inH * scale2);
			outW = (int) (inW * scale2);

			
			outImage = new int[3][outH][outW];

			for (int rgb = 0; rgb < 3; rgb++) {
				for (int i = 0; i < outH; i++) {
					for (int k = 0; k < outW; k++) {
						int r_H = (int)Math.round(i / scale2);
						int r_W = (int)Math.round(k / scale2);
						int i_H = r_H;
						int i_W = r_W;
						int s_H = Math.round(r_H - i_H);
						int s_W = Math.round(r_W - i_W);
						// console.log(i_H);
						if (i_H < 0 || i_H >= (inH - 1) || i_W < 0 || i_W >= (inW - 1)) {
							// point = i * outW + k;
							outImage[rgb][i][k] = 255;
						} else {
							C1 = inImage[rgb][i_H][i_W];
							C2 = inImage[rgb][i_H][i_W + 1];
							C3 = inImage[rgb][i_H + 1][i_W + 1];
							C4 = inImage[rgb][i_H + 1][i_W];
							newValue = (C1 * (1 - s_H) * (1 - s_W) + C2 * s_W * (1 - s_H) + C3 * s_W * s_H
									+ C4 * (1 - s_W) * s_H);
							outImage[rgb][i][k] = newValue;
						}

					}
				}
			}
			break;
		case "203":
			//상하반전
			outH = inH;
			outW = inW;
			// 메모리 할당
			outImage = new int[3][outH][outW];
			int temp;
			// 진짜 영상처리 알고리즘
			for (int rgb=0; rgb<3; rgb++)
			for(int i=0; i<inH; i++){
				for(int k=0; k<inW/2; k++){
					temp = inImage[rgb][i][k];
					inImage[rgb][i][k] = inImage[rgb][i][inW-k-1];
					inImage[rgb][i][inW-k-1] = temp;
				}
			}
			for (int rgb=0; rgb<3; rgb++)
			for(int i=0; i<inH; i++){
				for(int k=0; k<inW; k++){
					outImage[rgb][i][k] = inImage[rgb][i][k];
				}
			}
			break;
		case "204":
			//좌우반전outH = inH;
			outW = inW;
			// 메모리 할당
			outImage = new int[3][outH][outW];
			// 진짜 영상처리 알고리즘
			for (int rgb=0; rgb<3; rgb++)
			for(int i=0; i<inH/2; i++){
				for(int k=0; k<inW; k++){
					temp = inImage[rgb][i][k];
					inImage[rgb][i][k] = inImage[rgb][inH-i-1][k];
					inImage[rgb][inH-i-1][k] = temp;
				}
			}
			for (int rgb=0; rgb<3; rgb++)
			for(int i=0; i<inH; i++){
				for(int k=0; k<inW; k++){
					outImage[rgb][i][k] = inImage[rgb][i][k];
				}
			}
			break;
		case "205":
			//회전
			int CenterH, CenterW, newH, newW , Val;
			double Radian, PI;
			// PI = 3.14159265358979;
			PI = Math.PI;

			int degree = Integer.parseInt("30");
			
			Radian = -degree * PI / 180.0; 

			outH = (int)(Math.floor((inW) * Math.abs(Math.sin(Radian)) + (inH) * Math.abs(Math.cos(Radian))));
			outW = (int)(Math.floor((inW) * Math.abs(Math.cos(Radian)) + (inH) * Math.abs(Math.sin(Radian))));

			CenterH = outH / 2;
			CenterW = outW / 2;

			outImage = new int[3][outH][outW];
			
			for (int rgb = 0; rgb < 3; rgb++) {
				for (int i = 0; i < outH; i++) {
					for (int k = 0; k < outW; k++) {
						newH = (int)(
								(i - CenterH) * Math.cos(Radian) - (k - CenterW) * Math.sin(Radian) + inH / 2);
						newW = (int)(
								(i - CenterH) * Math.sin(Radian) + (k - CenterW) * Math.cos(Radian) + inW / 2);
						if (newH < 0 || newH >= inH) {
							//Val = 255;
							outImage[0][i][k] = 55;
							outImage[1][i][k] = 59;
							outImage[2][i][k] = 68;
									
						} else if (newW < 0 || newW >= inW) {
							//Val = 255;
							outImage[0][i][k] = 55;
							outImage[1][i][k] = 59;
							outImage[2][i][k] = 68;
						} else {
							Val = inImage[rgb][newH][newW];
							outImage[rgb][i][k] = Val;
						}
						
					}
				}
			}
			break;
		case "401":
			//엠보싱outH = inH;
			outW = inW;
			int[][] mask1 = {{-1,0,0},{0,0,0},{0,0,1}};
			int[][][] tmpImage1 = new int[3][inH+2][inW+2];
			
			for (int rgb=0; rgb<3; rgb++)
			for(int i=0; i<inH; i++){
				for(int k=0; k<inW; k++){
					tmpImage1[rgb][i][k] = 127;
				}
			}
			for (int rgb=0; rgb<3; rgb++)
			for(int i=0; i<inH; i++){
				for(int k=0; k<inW; k++){
					tmpImage1[rgb][i+1][k+1] = inImage[rgb][i][k];
				}
			}
		
			// 메모리 할당
			outImage = new int[3][outH][outW];
			// 진짜 영상처리 알고리즘
			for (int rgb=0; rgb<3; rgb++)
			for(int i=0; i<inH; i++){
				for(int k=0; k<inW; k++){
					int x = 0;
					for(int m=0; m<3; m++){
						for(int n=0; n<3; n++){
							x += mask1[m][n]*tmpImage1[rgb][i+m][k+n];
						}
					}
					x += 127;
					if(x > 255)
						x = 255;
					if(x < 0)
						x = 0;
					outImage[rgb][i][k] = x;
				}
			}
			break;
		case "402":
			//블러링outH = inH;
			outW = inW;
			double[][] mask2 = {{1.0/9.0,1.0/9.0,1.0/9.0},
					{1.0/9.0,1.0/9.0,1.0/9.0},
					{1.0/9.0,1.0/9.0,1.0/9.0}};
			int[][][] tmpImage2 = new int[3][inH+2][inW+2];
			
			for (int rgb=0; rgb<3; rgb++)
			for(int i=0; i<inH; i++){
				for(int k=0; k<inW; k++){
					tmpImage2[rgb][i+1][k+1] = inImage[rgb][i][k];
				}
			}
		
			// 메모리 할당
			outImage = new int[3][outH][outW];
			// 진짜 영상처리 알고리즘
			for (int rgb=0; rgb<3; rgb++)
			for(int i=0; i<inH; i++){
				for(int k=0; k<inW; k++){
					double x = 0.0;
					for(int m=0; m<3; m++){
						for(int n=0; n<3; n++){
							x += mask2[m][n]*tmpImage2[rgb][i+m][k+n];
						}
					}
					if(x > 255)
						x = 255;
					if(x < 0)
						x = 0;
					outImage[rgb][i][k] = (int)x;
				}
			}
			break;
		case "408":
			//경계선
			outH = inH;
			outW = inW;
			double[][] maskW ={{-1.0,-1.0,-1.0},
								{0.0,0.0,0.0},
								{1.0,1.0,1.0}};
			double[][] maskH ={{1.0,0.0,-1.0},
								{1.0,0.0,-1.0},
								{1.0,0.0,-1.0}};
			int[][][] tmpImageW = new int[3][inH+2][inW+2];
			int[][][] tmpImageH = new int[3][inH+2][inW+2];
			int[][][] tmpImageW2 = new int[3][inH][inW];
			int[][][] tmpImageH2 = new int[3][inH][inW];
			
			for (int rgb=0; rgb<3; rgb++)
			for(int i=0; i<inH; i++){
				for(int k=0; k<inW; k++){
					tmpImageW[rgb][i+1][k+1] = inImage[rgb][i][k];
					tmpImageH[rgb][i+1][k+1] = inImage[rgb][i][k];
				}
			}
		
			// 메모리 할당
			outImage = new int[3][outH][outW];
			// 진짜 영상처리 알고리즘
			for (int rgb=0; rgb<3; rgb++)
			for(int i=0; i<inH; i++){
				for(int k=0; k<inW; k++){
					double x = 0.0, y = 0.0;
					for(int m=0; m<3; m++){
						for(int n=0; n<3; n++){
							x += maskW[m][n]*tmpImageW[rgb][i+m][k+n];
							y += maskH[m][n]*tmpImageW[rgb][i+m][k+n];
						}
					}
					int v = (int)Math.sqrt(x*x + y*y);
					if(v>255)
						v = 255;
					else if(v<0)
						v = 0;
					outImage[rgb][i][k] = v;
				}
			}
			break;
		}
		
		UUID uuid = UUID.randomUUID(); //중복 
			
		//4. 결과물 파일에 쓰기
		File outFp;
		FileOutputStream outFs;
		String outName= uuid.toString()+"_out_"+filename;
		outFp = new File("c:/out/"+outName);
		//칼라 이미지 저장
		BufferedImage outCImage = 
		new BufferedImage(outH, outW, BufferedImage.TYPE_INT_RGB);
		
		//메모리 -> 파일
		for(int i=0; i<outH; i++){
			for(int k=0; k<outW; k++){
				int r = outImage[0][i][k];
				int g = outImage[1][i][k];
				int b = outImage[2][i][k];
				int px = 0;
				px = px | (r << 16);
				px = px | (g << 8);
				px = px | (b << 0);
				outCImage.setRGB(i,k,px);
			}
		}
		ImageIO.write(outCImage,"jpg", outFp);
		session.setAttribute("outName", outName); //세션 정보 설정
	 	response.sendRedirect("index.jsp");
	}
%>
