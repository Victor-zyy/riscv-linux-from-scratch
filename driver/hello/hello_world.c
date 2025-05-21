/***************************************************************************//**
*  \file       hello-module.c
*
*  \details    Simple hello world driver
*
*  \author     zyy 
*
* *******************************************************************************/
#include<linux/kernel.h>
#include<linux/init.h>
#include<linux/module.h>/* FIXME: for module info macro */
 
/*
** Module Init function
*/
static int __init hello_world_init(void)
{
    printk(KERN_INFO "Welcome to the beachworld\n");
    printk(KERN_INFO "This is the Simple Module\n");
    printk(KERN_INFO "Kernel Module Inserted Successfully...\n");
    return 0;
}

/*
** Module Exit function
*/
static void __exit hello_world_exit(void)
{
    printk(KERN_INFO "Kernel Module Removed Successfully...\n");
}
 
module_init(hello_world_init);
module_exit(hello_world_exit);
 
MODULE_LICENSE("GPL");
MODULE_AUTHOR("victor-zyy <gt7591665@gmail.com>");
MODULE_DESCRIPTION("A simple hello world driver");
MODULE_VERSION("1:1.0");
