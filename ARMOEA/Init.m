function PopDec = Init(obj,N)
            switch obj.Global.encoding
                case 'binary'
                    PopDec = randi([0,1],N,obj.Global.D);
                case 'permutation'
                    [~,PopDec] = sort(rand(N,obj.Global.D),2);
                otherwise
                    PopDec = unifrnd(repmat(obj.Global.lower,N,1),repmat(obj.Global.upper,N,1));
            end
end