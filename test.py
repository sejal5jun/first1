import tkinter as tk
from tkinter import *
import tkinter

dcps = {1: '',2:'DTC1',6:'DTC2',10:'DTC3'}
main_col = {2:'MilLamp',4: 'RedStopLamp',6: 'AmberWarningLamp',8: 'ProtectLamp'}
main_col_keys = {'MilLamp':'2','RedStopLamp':'4','AmberWarningLamp':'6','ProtectLamp':'8'}
entry_cords = {
    '12':{'22':{'32','42','52'},'62':{'72','82','92'},'102':{'112','122','132'}},
    '14':{'24':{'34','44','54'},'64':{'74','84','94'},'104':{'114','124','134'}},
    '16':{'26':{'36','46','56'},'66':{'76','86','96'},'106':{'116','126','136'}},
    '18':{'28':{'38','48','58'},'68':{'78','88','98'},'108':{'118','128','138'}},
}
att_label = {0:'SPN',1:'FMI',2:'COUNT'}
main_label = {0:'MilLamp',1:'RedStopLamp',2:'AmberWarningLamp',3:'ProtectLamp'}
labels = {
  **dict.fromkeys([3, 7, 11], 'SPN'),
  **dict.fromkeys([4,8,12], 'FMI'),
  **dict.fromkeys([5, 9,13], 'COUNT')
}
class Ui():
    def __init__(self, window):
        self.window = window
        self.cbList = {}
        self.entry = {}
        self.cbb_var = {}
        for i in range(1,14):
            for j in range(1,9):
                col = j*2
                if i in dcps.keys():
                    if col < 10:
                        arg = str(i)+str(col)
                        cb_var = IntVar()
                        cb = Checkbutton(self.window, onvalue=1, offvalue=0, text = main_col[col] if i == 1 else dcps[i], variable=cb_var)
                        cb.grid(row=i, column=col)
                        cb.bind("<Button-1>",lambda event, self=self,arg=arg:self.clicked(event,arg))
                        self.cbList[arg] = cb
                        self.cbb_var[arg] = cb_var
                else:
                    if j%2 == 0:
                        en = Entry(window,state=DISABLED)
                        en.grid(row=i,column=j)
                        self.entry[str(i)+str(j)] = en
                    else:
                        Label(window, text = labels[i]).grid(row=i,column=j)
        b = Button(window,text="Get DTC Messages",command=self.getData)
        b.grid(row=14,column=8,pady=10)

    def clicked(self, event, arg):
        cb_btn = event.widget
        var_text = cb_btn.cget("text")
        if var_text in main_col.values():
            if self.cbb_var[arg].get() == 1:
                for i,j in entry_cords[arg].items():
                    self.cbList[i].deselect()
                    for k in j:
                        self.entry[k].delete(0, tk.END)
                        self.entry[k].config(state=DISABLED)
        else:
            new = int(arg) + 10
            for j in range(0,3):
                if self.cbb_var[arg].get() == 0:
                    self.entry[str(new)].config(state=NORMAL)
                else:
                    self.entry[str(new)].delete(0, tk.END)
                    self.entry[str(new)].config(state=DISABLED)
                new = new + 10

    def getMainString(self):
        on_off = {0:'Off',1:'On'}
        att = 0
        final_string = ''
        for i in entry_cords.keys():
            final_string = final_string + '<'+main_label[att]+'>'+on_off[self.cbb_var[i].get()]+'</'+main_label[att]+'/>'
            att = att + 1
        return final_string

    def getData(self):
        main_string = self.getMainString()
        for cor,cor_entry in entry_cords.items():
            if self.cbb_var[cor].get() == 1:
                for key,en_val in cor_entry.items():
                    if self.cbb_var[key].get() == 1:
                        att = 0
                        main_string = main_string + '<DTC>'
                        for v in en_val:
                            main_string = main_string+'<'+att_label[att]+'>'+self.entry[v].get()+'</'+att_label[att]+'>'
                            att = att + 1
                        main_string = main_string + '</DTC></DTCs>'
        return main_string

window = tk.Tk()
window.geometry('720x335')
window.title("DTC Simulation")
Ui(window)
window.mainloop()