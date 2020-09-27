git clone -b fix https://github.com/biluohc/erlang-secp256k1 && cd erlang-secp256k1

#### rebar3 
https://github.com/erlang/rebar3#should-i-use-rebar3

```
wget https://s3.amazonaws.com/rebar3/rebar3 && chmod +x rebar3
```

```sh
./secp256k1.sh && ls -lah priv/

./rebar3 shell  or  ./rebar3 compile && erl -pa _build/default/lib/secp256k1/ebin
```

```sh
Erlang/OTP 22 [erts-10.6.4] [source] [64-bit] [smp:24:24] [ds:24:24:10] [async-threads:1] [hipe]
Eshell V10.6.4  (abort with ^G)
1>
1> Sk = <<48, 34, 215, 123, 88, 242, 186, 2, 73, 243, 4, 253, 103, 25, 189, 12, 36, 84, 137, 107, 233, 22, 68, 98, 142, 179, 226, 97, 195, 108, 146, 89>>.
<<48,34,215,123,88,242,186,2,73,243,4,253,103,25,189,12,
  36,84,137,107,233,22,68,98,142,179,226,97,195,...>>
2> Sk2 = crypto:strong_rand_bytes(32).
<<186,233,183,121,241,89,49,13,29,154,242,129,187,216,15,
  251,84,212,10,211,217,146,224,142,204,16,94,80,67,...>>
4> Pk = secp256k1:secp256k1_ec_pubkey_create(Sk, false).
<<4,135,227,79,237,134,231,230,82,12,198,157,117,171,153,
  41,169,124,214,57,110,138,151,204,97,194,1,169,238,...>>
5> io:fwrite("W.new pubk: ~p ~n", [ Pk ]).
W.new pubk: <<4,135,227,79,237,134,231,230,82,12,198,157,117,171,153,41,169,
              124,214,57,110,138,151,204,97,194,1,169,238,238,73,39,66,144,66,
              41,18,190,14,204,253,251,236,160,147,143,9,119,47,212,11,181,197,
              77,155,14,108,60,31,179,177,79,157,138,239>>
ok
6> Msg32 = crypto:hash(sha256, list_to_binary("h")).
<<170,169,64,38,100,241,164,31,64,235,188,82,201,153,62,
  182,106,235,54,102,2,149,143,223,170,40,59,113,230,...>>
7> Sb = secp256k1:secp256k1_ecdsa_sign(Msg32, Sk, default, <<>>).
<<48,68,2,32,68,20,56,29,135,172,178,28,90,68,205,203,74,
  116,248,7,133,167,217,163,110,55,89,173,246,...>>
8>
8> secp256k1:secp256k1_ecdsa_verify(Msg32, Sb, Pk).
correct
9> secp256k1:secp256k1_ecdsa_verify(Msg32, Sb, Sk).
invalid_public_key
10> secp256k1:secp256k1_ecdsa_verify(Msg32, Sb, secp256k1:secp256k1_ec_pubkey_create(Sk2, false)).
incorrect
11>
```

<!-- the secp256k1 in crypto is fake -->
```erlang
sign({Priv, _Pub}, Data) ->
	% crypto:sign(ecdsa, sha256, Data, [Priv, secp256k1]).
	Msg32 = crypto:hash(sha256, Data),
	secp256k1:secp256k1_ecdsa_sign(Msg32, Priv, default, <<>>).

% returns true or false
verify(Key, Data, Sig) ->
	% crypto:verify(ecdsa, sha256, Data, Sig,  [Key, secp256k1] ).
	Msg32 = crypto:hash(sha256, Data),
	case secp256k1:secp256k1_ecdsa_verify(Msg32, Sig,  Key) of
		correct -> true;
		_ -> false
	end.
```
