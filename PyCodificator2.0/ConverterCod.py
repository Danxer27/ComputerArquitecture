import tkinter as tk
from tkinter import messagebox, filedialog

def convertir_a_binario(instruccion):
    instruccion = instruccion.replace(",", "")
    partes = instruccion.split()
    
    if not partes:
        return None
    
    opcode = "000000"  # Opcode para instrucciones tipo R en MIPS
    funct_dict = {"add": "100000", "sub": "100010", "and": "100100", "or": "100101", "slt": "101010"}
    
    try:
        funct = funct_dict.get(partes[0].lower(), None)
        if funct is None:
            raise ValueError("Operación no reconocida")
        
        rd = format(int(partes[1][1:]), '05b')
        rs = format(int(partes[2][1:]), '05b')
        rt = format(int(partes[3][1:]), '05b')
        shamt = "00000"  # Shift amount siempre 0 para estas instrucciones
        
        resultado = f"{opcode}{rs}{rt}{rd}{shamt}{funct}"
        return resultado
    except Exception:
        return None

def procesar_entrada_manual():
    instruccion = entrada_texto.get()
    resultado = convertir_a_binario(instruccion)
    if resultado:
        etiqueta_resultado.config(text=f"Binario: {resultado}")
        guardar_en_archivo_verilog([(instruccion, resultado)])
    else:
        messagebox.showerror("Error", "Formato de instrucción incorrecto.")

def procesar_archivo():
    archivo_seleccionado = filedialog.askopenfilename(filetypes=[("Archivos de texto", "*.txt")])
    if not archivo_seleccionado:
        return
    
    instrucciones_binarias = []
    try:
        with open(archivo_seleccionado, "r") as archivo:
            for linea in archivo:
                linea = linea.strip()
                resultado = convertir_a_binario(linea)
                if resultado:
                    instrucciones_binarias.append((linea, resultado))
        guardar_en_archivo_verilog(instrucciones_binarias)
        messagebox.showinfo("Éxito", "Archivo procesado correctamente.")
    except Exception as e:
        messagebox.showerror("Error", f"No se pudo procesar el archivo: {e}")

def guardar_en_archivo_verilog(instrucciones):
    if not ruta_archivo.get():
        messagebox.showerror("Error", "Seleccione una ruta para guardar el archivo.")
        return
    
    with open(ruta_archivo.get(), "w") as archivo:
        archivo.write("module instrucciones_memoria;\n")
        archivo.write("    reg [31:0] memoria [0:{}];\n".format(len(instrucciones) - 1))
        archivo.write("    initial begin\n")
        for i, (instr, binario) in enumerate(instrucciones):
            archivo.write(f"        memoria[{i}] = 32'b{binario}; // {instr}\n")
        archivo.write("    end\n")
        archivo.write("endmodule\n")

def seleccionar_archivo_salida():
    archivo_seleccionado = filedialog.asksaveasfilename(defaultextension=".v", filetypes=[("Archivos Verilog", "*.v")])
    if archivo_seleccionado:
        ruta_archivo.set(archivo_seleccionado)

# Crear la ventana principal
ventana = tk.Tk()
ventana.title("Conversor de Instrucciones MIPS a Binario (Verilog)")
ventana.geometry("500x400")
ventana.configure(bg="#2C3E50")

ruta_archivo = tk.StringVar()

# Widgets con colores y estilos
etiqueta = tk.Label(ventana, text="Ingrese la instrucción:", bg="#2C3E50", fg="white", font=("Arial", 12))
etiqueta.pack(pady=5)

entrada_texto = tk.Entry(ventana, width=50, font=("Arial", 12), bg="#ECF0F1", fg="#2C3E50")
entrada_texto.pack(pady=5)

boton_convertir = tk.Button(ventana, text="Convertir", command=procesar_entrada_manual, bg="#3498DB", fg="white", font=("Arial", 12), padx=10, pady=5)
boton_convertir.pack(pady=5)

etiqueta_resultado = tk.Label(ventana, text="Binario: ", bg="#2C3E50", fg="white", font=("Arial", 12))
etiqueta_resultado.pack(pady=5)

boton_archivo = tk.Button(ventana, text="Procesar Archivo de Instrucciones", command=procesar_archivo, bg="#F39C12", fg="white", font=("Arial", 12), padx=10, pady=5)
boton_archivo.pack(pady=5)

frame_guardado = tk.Frame(ventana, bg="#2C3E50")
frame_guardado.pack(pady=5)

entrada_archivo = tk.Entry(frame_guardado, textvariable=ruta_archivo, width=40, font=("Arial", 12), bg="#ECF0F1", fg="#2C3E50")
entrada_archivo.pack(side=tk.LEFT, padx=5)

boton_seleccionar = tk.Button(frame_guardado, text="Seleccionar Archivo de Salida", command=seleccionar_archivo_salida, bg="#E74C3C", fg="white", font=("Arial", 12), padx=10, pady=5)
boton_seleccionar.pack(side=tk.RIGHT)

# Ejecutar la aplicación
ventana.mainloop()
