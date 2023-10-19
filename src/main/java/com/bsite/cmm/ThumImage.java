package com.bsite.cmm;

import java.awt.image.BufferedImage;
import java.io.File;

import javax.imageio.ImageIO;

import com.mortennobel.imagescaling.AdvancedResizeOp;
import com.mortennobel.imagescaling.ResampleOp;




public class ThumImage {
	
	
	/** 썸네일 **/
	public boolean scale( BufferedImage srcImage, String destPath, String imageFormat, int destWidth, int  destHeight) {
		
		boolean result = true;
		
		
		try{
			ResampleOp resampleOp = new  ResampleOp(destWidth, destHeight);
			resampleOp.setUnsharpenMask(AdvancedResizeOp.UnsharpenMask.Soft);
			
			BufferedImage rescaledImage = resampleOp.filter(srcImage, null);
			File destFile = new File(destPath);
			ImageIO.write(rescaledImage, imageFormat, destFile);
			
			
		}catch(Exception e){
			System.out.println("썸네일 예외 : "+e.getCause());
			result = false;
		}
		
		
		return result;
	}
	
	
	
}
