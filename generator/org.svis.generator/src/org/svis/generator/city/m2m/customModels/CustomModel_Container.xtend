package org.svis.generator.city.m2m.customModels

import org.svis.generator.city.CityUtils

class CustomModel_Container {
    def static String defineContainerShape()'''
	    <Transform rotation='0.000000 0.707107 0.707107 3.141593'>
		<Group DEF="Container">
			<Shape>
				<Appearance>
					<Material DEF="MA_Material_001"
					          diffuseColor="«CityUtils.getRGBFromHEX("#171919")»"
					          specularColor="0.401 0.401 0.401"
					          emissiveColor="0.000 0.000 0.000"
					          ambientIntensity="0.333"
					          shininess="0.098"
					          transparency="0.0"
					          />
				</Appearance>
				<IndexedFaceSet solid="true"
				                coordIndex="0 1 2 3 -1 4 5 6 7 -1 8 9 10 11 -1 12 13 14 15 -1 16 17 18 19 -1 20 21 22 23 -1 24 25 26 27 -1 28 29 30 31 -1 32 33 34 35 -1 36 37 38 39 -1 40 41 42 43 -1 44 45 46 47 -1 48 49 50 51 -1 52 53 54 55 -1 56 57 58 59 -1 60 61 62 63 -1 64 65 66 67 -1 68 69 70 71 -1 72 73 74 75 -1 76 77 78 79 -1 80 81 82 83 -1 84 85 86 87 -1 88 89 90 91 -1 92 93 94 95 -1 96 97 98 99 -1 100 101 102 103 -1 104 105 106 107 -1 108 109 110 111 -1 112 113 114 115 -1 116 117 118 119 -1 120 121 122 123 -1 124 125 126 127 -1 128 129 130 131 -1 132 133 134 135 -1 136 137 138 139 -1 140 141 142 143 -1 144 145 146 147 -1 148 149 150 151 -1 152 153 154 155 -1 156 157 158 159 -1 160 161 162 163 -1 164 165 166 167 -1 168 169 170 171 -1 172 173 174 175 -1 176 177 178 179 -1 180 181 182 183 -1 184 185 186 187 -1 188 189 190 191 -1 192 193 194 195 -1 196 197 198 199 -1 200 201 202 203 -1 204 205 206 207 -1 208 209 210 211 -1 212 213 214 215 -1 216 217 218 219 -1 220 221 222 223 -1 224 225 226 227 -1 228 229 230 231 -1 232 233 234 235 -1 236 237 238 239 -1 240 241 242 243 -1 244 245 246 247 -1 248 249 250 251 -1 252 253 254 255 -1 256 257 258 259 -1 260 261 262 263 -1 264 265 266 267 -1 268 269 270 271 -1 272 273 274 275 -1 276 277 278 279 -1 280 281 282 283 -1 284 285 286 287 -1 288 289 290 291 -1 292 293 294 295 -1 296 297 298 299 -1 300 301 302 303 -1 304 305 306 307 -1 308 309 310 311 -1 312 313 314 315 -1 316 317 318 319 -1 320 321 322 323 -1 324 325 326 327 -1 328 329 330 331 -1 332 333 334 335 -1 336 337 338 339 -1 340 341 342 343 -1 344 345 346 347 -1 348 349 350 351 -1 352 353 354 355 -1 356 357 358 359 -1 360 361 362 363 -1 364 365 366 367 -1 368 369 370 371 -1 372 373 374 375 -1 376 377 378 379 -1 380 381 382 383 -1 384 385 386 387 -1 388 389 390 391 -1 392 393 394 395 -1 396 397 398 399 -1 400 401 402 403 -1 404 405 406 407 -1 "
				                >
					<Coordinate DEF="coords_ME_container"
					            point="-4.000000 1.000000 0.000000 -4.000000 1.000000 1.000000 -4.000000 2.000000 1.000000 -4.000000 2.000000 0.000000 -4.000000 2.000000 0.000000 -4.000000 2.000000 1.000000 -4.000000 3.000000 1.000000 -4.000000 3.000000 0.000000 -4.000000 3.000000 0.000000 -4.000000 3.000000 1.000000 -4.000000 4.000000 1.000000 -4.000000 4.000000 0.000000 -4.000000 1.000000 1.000000 -4.000000 1.000000 2.000000 -4.000000 2.000000 2.000000 -4.000000 2.000000 1.000000 -4.000000 2.000000 1.000000 -4.000000 2.000000 2.000000 -4.000000 3.000000 2.000000 -4.000000 3.000000 1.000000 -4.000000 3.000000 1.000000 -4.000000 3.000000 2.000000 -4.000000 4.000000 2.000000 -4.000000 4.000000 1.000000 -4.000000 1.000000 2.000000 -4.000000 1.000000 3.000000 -4.000000 2.000000 3.000000 -4.000000 2.000000 2.000000 -4.000000 2.000000 2.000000 -4.000000 2.000000 3.000000 -4.000000 3.000000 3.000000 -4.000000 3.000000 2.000000 -4.000000 3.000000 2.000000 -4.000000 3.000000 3.000000 -4.000000 4.000000 3.000000 -4.000000 4.000000 2.000000 3.000000 1.000000 0.000000 3.000000 2.000000 0.000000 3.000000 2.000000 1.000000 3.000000 1.000000 1.000000 3.000000 2.000000 0.000000 3.000000 3.000000 0.000000 3.000000 3.000000 1.000000 3.000000 2.000000 1.000000 3.000000 3.000000 0.000000 3.000000 4.000000 0.000000 3.000000 4.000000 1.000000 3.000000 3.000000 1.000000 3.000000 1.000000 1.000000 3.000000 2.000000 1.000000 3.000000 2.000000 2.000000 3.000000 1.000000 2.000000 3.000000 2.000000 1.000000 3.000000 3.000000 1.000000 3.000000 3.000000 2.000000 3.000000 2.000000 2.000000 3.000000 3.000000 1.000000 3.000000 4.000000 1.000000 3.000000 4.000000 2.000000 3.000000 3.000000 2.000000 3.000000 1.000000 2.000000 3.000000 2.000000 2.000000 3.000000 2.000000 3.000000 3.000000 1.000000 3.000000 3.000000 2.000000 2.000000 3.000000 3.000000 2.000000 3.000000 3.000000 3.000000 3.000000 2.000000 3.000000 3.000000 3.000000 2.000000 3.000000 4.000000 2.000000 3.000000 4.000000 3.000000 3.000000 3.000000 3.000000 -4.000000 1.000000 0.000000 -3.000000 1.000000 0.000000 -3.000000 1.000000 1.000000 -4.000000 1.000000 1.000000 -3.000000 1.000000 0.000000 -2.000000 1.000000 0.000000 -2.000000 1.000000 1.000000 -3.000000 1.000000 1.000000 -2.000000 1.000000 0.000000 -1.000000 1.000000 0.000000 -1.000000 1.000000 1.000000 -2.000000 1.000000 1.000000 -1.000000 1.000000 0.000000 0.000000 1.000000 0.000000 0.000000 1.000000 1.000000 -1.000000 1.000000 1.000000 0.000000 1.000000 0.000000 1.000000 1.000000 0.000000 1.000000 1.000000 1.000000 0.000000 1.000000 1.000000 1.000000 1.000000 0.000000 2.000000 1.000000 0.000000 2.000000 1.000000 1.000000 1.000000 1.000000 1.000000 2.000000 1.000000 0.000000 3.000000 1.000000 0.000000 3.000000 1.000000 1.000000 2.000000 1.000000 1.000000 -4.000000 1.000000 1.000000 -3.000000 1.000000 1.000000 -3.000000 1.000000 2.000000 -4.000000 1.000000 2.000000 -3.000000 1.000000 1.000000 -2.000000 1.000000 1.000000 -2.000000 1.000000 2.000000 -3.000000 1.000000 2.000000 -2.000000 1.000000 1.000000 -1.000000 1.000000 1.000000 -1.000000 1.000000 2.000000 -2.000000 1.000000 2.000000 -1.000000 1.000000 1.000000 0.000000 1.000000 1.000000 0.000000 1.000000 2.000000 -1.000000 1.000000 2.000000 0.000000 1.000000 1.000000 1.000000 1.000000 1.000000 1.000000 1.000000 2.000000 0.000000 1.000000 2.000000 1.000000 1.000000 1.000000 2.000000 1.000000 1.000000 2.000000 1.000000 2.000000 1.000000 1.000000 2.000000 2.000000 1.000000 1.000000 3.000000 1.000000 1.000000 3.000000 1.000000 2.000000 2.000000 1.000000 2.000000 -4.000000 1.000000 2.000000 -3.000000 1.000000 2.000000 -3.000000 1.000000 3.000000 -4.000000 1.000000 3.000000 -3.000000 1.000000 2.000000 -2.000000 1.000000 2.000000 -2.000000 1.000000 3.000000 -3.000000 1.000000 3.000000 -2.000000 1.000000 2.000000 -1.000000 1.000000 2.000000 -1.000000 1.000000 3.000000 -2.000000 1.000000 3.000000 -1.000000 1.000000 2.000000 0.000000 1.000000 2.000000 0.000000 1.000000 3.000000 -1.000000 1.000000 3.000000 0.000000 1.000000 2.000000 1.000000 1.000000 2.000000 1.000000 1.000000 3.000000 0.000000 1.000000 3.000000 1.000000 1.000000 2.000000 2.000000 1.000000 2.000000 2.000000 1.000000 3.000000 1.000000 1.000000 3.000000 2.000000 1.000000 2.000000 3.000000 1.000000 2.000000 3.000000 1.000000 3.000000 2.000000 1.000000 3.000000 -4.000000 4.000000 0.000000 -4.000000 4.000000 1.000000 -3.000000 4.000000 1.000000 -3.000000 4.000000 0.000000 -3.000000 4.000000 0.000000 -3.000000 4.000000 1.000000 -2.000000 4.000000 1.000000 -2.000000 4.000000 0.000000 -2.000000 4.000000 0.000000 -2.000000 4.000000 1.000000 -1.000000 4.000000 1.000000 -1.000000 4.000000 0.000000 -1.000000 4.000000 0.000000 -1.000000 4.000000 1.000000 0.000000 4.000000 1.000000 0.000000 4.000000 0.000000 0.000000 4.000000 0.000000 0.000000 4.000000 1.000000 1.000000 4.000000 1.000000 1.000000 4.000000 0.000000 1.000000 4.000000 0.000000 1.000000 4.000000 1.000000 2.000000 4.000000 1.000000 2.000000 4.000000 0.000000 2.000000 4.000000 0.000000 2.000000 4.000000 1.000000 3.000000 4.000000 1.000000 3.000000 4.000000 0.000000 -4.000000 4.000000 1.000000 -4.000000 4.000000 2.000000 -3.000000 4.000000 2.000000 -3.000000 4.000000 1.000000 -3.000000 4.000000 1.000000 -3.000000 4.000000 2.000000 -2.000000 4.000000 2.000000 -2.000000 4.000000 1.000000 -2.000000 4.000000 1.000000 -2.000000 4.000000 2.000000 -1.000000 4.000000 2.000000 -1.000000 4.000000 1.000000 -1.000000 4.000000 1.000000 -1.000000 4.000000 2.000000 0.000000 4.000000 2.000000 0.000000 4.000000 1.000000 0.000000 4.000000 1.000000 0.000000 4.000000 2.000000 1.000000 4.000000 2.000000 1.000000 4.000000 1.000000 1.000000 4.000000 1.000000 1.000000 4.000000 2.000000 2.000000 4.000000 2.000000 2.000000 4.000000 1.000000 2.000000 4.000000 1.000000 2.000000 4.000000 2.000000 3.000000 4.000000 2.000000 3.000000 4.000000 1.000000 -4.000000 4.000000 2.000000 -4.000000 4.000000 3.000000 -3.000000 4.000000 3.000000 -3.000000 4.000000 2.000000 -3.000000 4.000000 2.000000 -3.000000 4.000000 3.000000 -2.000000 4.000000 3.000000 -2.000000 4.000000 2.000000 -2.000000 4.000000 2.000000 -2.000000 4.000000 3.000000 -1.000000 4.000000 3.000000 -1.000000 4.000000 2.000000 -1.000000 4.000000 2.000000 -1.000000 4.000000 3.000000 0.000000 4.000000 3.000000 0.000000 4.000000 2.000000 0.000000 4.000000 2.000000 0.000000 4.000000 3.000000 1.000000 4.000000 3.000000 1.000000 4.000000 2.000000 1.000000 4.000000 2.000000 1.000000 4.000000 3.000000 2.000000 4.000000 3.000000 2.000000 4.000000 2.000000 2.000000 4.000000 2.000000 2.000000 4.000000 3.000000 3.000000 4.000000 3.000000 3.000000 4.000000 2.000000 -4.000000 1.000000 0.000000 -4.000000 2.000000 0.000000 -3.000000 2.000000 0.000000 -3.000000 1.000000 0.000000 -3.000000 1.000000 0.000000 -3.000000 2.000000 0.000000 -2.000000 2.000000 0.000000 -2.000000 1.000000 0.000000 -2.000000 1.000000 0.000000 -2.000000 2.000000 0.000000 -1.000000 2.000000 0.000000 -1.000000 1.000000 0.000000 -1.000000 1.000000 0.000000 -1.000000 2.000000 0.000000 0.000000 2.000000 0.000000 0.000000 1.000000 0.000000 0.000000 1.000000 0.000000 0.000000 2.000000 0.000000 1.000000 2.000000 0.000000 1.000000 1.000000 0.000000 1.000000 1.000000 0.000000 1.000000 2.000000 0.000000 2.000000 2.000000 0.000000 2.000000 1.000000 0.000000 2.000000 1.000000 0.000000 2.000000 2.000000 0.000000 3.000000 2.000000 0.000000 3.000000 1.000000 0.000000 -4.000000 2.000000 0.000000 -4.000000 3.000000 0.000000 -3.000000 3.000000 0.000000 -3.000000 2.000000 0.000000 -3.000000 2.000000 0.000000 -3.000000 3.000000 0.000000 -2.000000 3.000000 0.000000 -2.000000 2.000000 0.000000 -2.000000 2.000000 0.000000 -2.000000 3.000000 0.000000 -1.000000 3.000000 0.000000 -1.000000 2.000000 0.000000 -1.000000 2.000000 0.000000 -1.000000 3.000000 0.000000 0.000000 3.000000 0.000000 0.000000 2.000000 0.000000 0.000000 2.000000 0.000000 0.000000 3.000000 0.000000 1.000000 3.000000 0.000000 1.000000 2.000000 0.000000 1.000000 2.000000 0.000000 1.000000 3.000000 0.000000 2.000000 3.000000 0.000000 2.000000 2.000000 0.000000 2.000000 2.000000 0.000000 2.000000 3.000000 0.000000 3.000000 3.000000 0.000000 3.000000 2.000000 0.000000 -4.000000 3.000000 0.000000 -4.000000 4.000000 0.000000 -3.000000 4.000000 0.000000 -3.000000 3.000000 0.000000 -3.000000 3.000000 0.000000 -3.000000 4.000000 0.000000 -2.000000 4.000000 0.000000 -2.000000 3.000000 0.000000 -2.000000 3.000000 0.000000 -2.000000 4.000000 0.000000 -1.000000 4.000000 0.000000 -1.000000 3.000000 0.000000 -1.000000 3.000000 0.000000 -1.000000 4.000000 0.000000 0.000000 4.000000 0.000000 0.000000 3.000000 0.000000 0.000000 3.000000 0.000000 0.000000 4.000000 0.000000 1.000000 4.000000 0.000000 1.000000 3.000000 0.000000 1.000000 3.000000 0.000000 1.000000 4.000000 0.000000 2.000000 4.000000 0.000000 2.000000 3.000000 0.000000 2.000000 3.000000 0.000000 2.000000 4.000000 0.000000 3.000000 4.000000 0.000000 3.000000 3.000000 0.000000 -4.000000 1.000000 3.000000 -3.000000 1.000000 3.000000 -3.000000 2.000000 3.000000 -4.000000 2.000000 3.000000 -3.000000 1.000000 3.000000 -2.000000 1.000000 3.000000 -2.000000 2.000000 3.000000 -3.000000 2.000000 3.000000 -2.000000 1.000000 3.000000 -1.000000 1.000000 3.000000 -1.000000 2.000000 3.000000 -2.000000 2.000000 3.000000 -1.000000 1.000000 3.000000 0.000000 1.000000 3.000000 0.000000 2.000000 3.000000 -1.000000 2.000000 3.000000 0.000000 1.000000 3.000000 1.000000 1.000000 3.000000 1.000000 2.000000 3.000000 0.000000 2.000000 3.000000 1.000000 1.000000 3.000000 2.000000 1.000000 3.000000 2.000000 2.000000 3.000000 1.000000 2.000000 3.000000 2.000000 1.000000 3.000000 3.000000 1.000000 3.000000 3.000000 2.000000 3.000000 2.000000 2.000000 3.000000 -4.000000 2.000000 3.000000 -3.000000 2.000000 3.000000 -3.000000 3.000000 3.000000 -4.000000 3.000000 3.000000 -3.000000 2.000000 3.000000 -2.000000 2.000000 3.000000 -2.000000 3.000000 3.000000 -3.000000 3.000000 3.000000 -2.000000 2.000000 3.000000 -1.000000 2.000000 3.000000 -1.000000 3.000000 3.000000 -2.000000 3.000000 3.000000 -1.000000 2.000000 3.000000 0.000000 2.000000 3.000000 0.000000 3.000000 3.000000 -1.000000 3.000000 3.000000 0.000000 2.000000 3.000000 1.000000 2.000000 3.000000 1.000000 3.000000 3.000000 0.000000 3.000000 3.000000 1.000000 2.000000 3.000000 2.000000 2.000000 3.000000 2.000000 3.000000 3.000000 1.000000 3.000000 3.000000 2.000000 2.000000 3.000000 3.000000 2.000000 3.000000 3.000000 3.000000 3.000000 2.000000 3.000000 3.000000 -4.000000 3.000000 3.000000 -3.000000 3.000000 3.000000 -3.000000 4.000000 3.000000 -4.000000 4.000000 3.000000 -3.000000 3.000000 3.000000 -2.000000 3.000000 3.000000 -2.000000 4.000000 3.000000 -3.000000 4.000000 3.000000 -2.000000 3.000000 3.000000 -1.000000 3.000000 3.000000 -1.000000 4.000000 3.000000 -2.000000 4.000000 3.000000 -1.000000 3.000000 3.000000 0.000000 3.000000 3.000000 0.000000 4.000000 3.000000 -1.000000 4.000000 3.000000 0.000000 3.000000 3.000000 1.000000 3.000000 3.000000 1.000000 4.000000 3.000000 0.000000 4.000000 3.000000 1.000000 3.000000 3.000000 2.000000 3.000000 3.000000 2.000000 4.000000 3.000000 1.000000 4.000000 3.000000 2.000000 3.000000 3.000000 3.000000 3.000000 3.000000 3.000000 4.000000 3.000000 2.000000 4.000000 3.000000 "
					            />
				</IndexedFaceSet>
			</Shape>              
		</Group>
		</Transform>
	'''

	def static createContainerShape()'''
		<Transform rotation='0.000000 0.707107 0.707107 3.141593'>
			<Group USE="Container"/>
		</Transform>
	'''
}